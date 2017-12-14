//
//  MapViewController.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 11. 11..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MapKit
import MBProgressHUD

class MapViewController: UIViewController {

    // MARK: - let constants

    let disposeBag = DisposeBag()

    // The viewmodel must be let!
    // To prevent memory leaks change the model inside the viewmodel instead of changing the viewmodel object.
    let viewModel = MapViewModel()

    // MARK: - var variables

    // MARK: - Interface Builder Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profileButton: UIBarButtonItem!

    // MARK: - UIViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showPlaceDetails(_:)), name: Constants.Notifications.MapShowPlaceDetails, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getDirections(_:)), name: Constants.Notifications.MapGetDirections, object: nil)

        viewModel.isLoading.asObservable().throttle(1.0, latest: true, scheduler: MainScheduler.instance).subscribe { [weak self] (event) in
            guard let strongSelf = self else { return }
            guard let isLoading = event.element else { return }
            if isLoading {
                MBProgressHUD.showAdded(to: strongSelf.view, animated: true)
            } else {
                MBProgressHUD.hide(for: strongSelf.view, animated: true)
            }
            }.disposed(by: disposeBag)
        
        viewModel.isLoading.asObservable().map { !$0 }.throttle(1.0, latest: true, scheduler: MainScheduler.instance).bind(to: profileButton.rx.isEnabled).disposed(by: disposeBag)

        
        viewModel.annotations.asObservable().subscribe { [weak self] (event) in
            self?.mapView.removeAnnotations(self?.mapView.annotations ?? [])
            guard let annotations = event.element else { return }
            for annotation in annotations {
                self?.mapView?.addAnnotation(annotation)
            }
            self?.zoomMapFitAnnotations()
            }.disposed(by: disposeBag)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowPlaceDetails" {
            if let destination = segue.destination as? PlaceDetailsViewController {
                if let place = sender as? Place {
                    destination.viewModel.place.value = place
                }
            }
        } else if segue.identifier == "ShowMapOptions" {
            if let destination = segue.destination as? MapOptionsTableViewController {
                destination.viewModel.places.value = viewModel.places.value
                destination.viewModel.placeTypesToFilter.value = viewModel.placeTypesToFilter.value
            }
        }
    }

    // MARK: - Helper Methods

    func zoomMapFitAnnotations() {
        var zoomRect = MKMapRectNull
        for annotation in mapView.annotations {
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
            if MKMapRectIsNull(zoomRect) {
                zoomRect = pointRect
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect)
            }
        }
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets.init(top: 80, left: 50, bottom: 60, right: 50), animated: true)
    }
}

// MARK: - Interface Builder Actions

extension MapViewController {
    func showPlaceMenu(_ place: Place, _ view: MKAnnotationView) {
        let actionSheetController = MapMenuViewController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheetController.place = place
        actionSheetController.popoverPresentationController?.sourceView = view
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func showProfile(_ sender: UIBarButtonItem?) {
        viewModel.isLoading.value = true
        Authenticator.shared.authenticate(with: .facebook) { [weak self] (user, error) in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.isLoading.value = false
            if error != nil {
                let alert = UIAlertController(title: "Login.Error.Title".localized, message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Login.Error.Ok.Button".localized, style: UIAlertActionStyle.default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
            }
            if let user = user {
                strongSelf.performSegue(withIdentifier: "ShowProfile", sender: nil)
            }
        }
    }
}

// MARK: - Notification handlers can be placed here

extension MapViewController {
    @objc func showPlaceDetails(_ notification: Notification) {
        guard let place = notification.object as? Place else { return }
        performSegue(withIdentifier: "ShowPlaceDetails", sender: place)
    }

    @objc func getDirections(_ notification: Notification) {
        guard let place = notification.object as? Place else { return }

        let latitude: CLLocationDegrees = place.location.latitude
        let longitude: CLLocationDegrees = place.location.longitude
        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = place.name
        mapItem.openInMaps(launchOptions: options)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MKPlaceAnnotaion else { return nil }

        let identifier = "marker"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: 0, y: 5)
            let accessoryView = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView = accessoryView
        }
        return view
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? MKPlaceAnnotaion else { return }
        showPlaceMenu(annotation.place, view)
    }
}
