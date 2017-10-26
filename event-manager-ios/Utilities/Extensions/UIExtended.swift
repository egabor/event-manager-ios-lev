//
//  UIExtended.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import UIKit

extension UIButton {
    @IBInspectable var localizedTitle: String {
        get {
            return titleLabel?.text ?? ""
        }
        set {
            #if TARGET_INTERFACE_BUILDER
                var bundle = NSBundle(forClass: type(of: self))
                setTitle(bundle.localizedStringForKey(newValue, value: "", table: nil), for: .normal)
            #else
                setTitle(newValue.localized, for: .normal)
            #endif
        }
    }
}

extension UINavigationItem {
    @IBInspectable var localizedTitle: String {
        get {
            return title ?? ""
        }
        set {
            #if TARGET_INTERFACE_BUILDER
                var bundle = NSBundle(forClass: type(of: self))
                title = bundle.localizedStringForKey(newValue, value: "", table: nil)
            #else
                title = newValue.localized
            #endif
        }
    }
}

extension UIBarButtonItem {
    @IBInspectable var localizedTitle: String {
        get {
            return title ?? ""
        }
        set {
            #if TARGET_INTERFACE_BUILDER
                var bundle = NSBundle(forClass: type(of: self))
                title = bundle.localizedStringForKey(newValue, value: "", table: nil)
            #else
                title = newValue.localized
            #endif
        }
    }
}

extension UILabel {
    @IBInspectable var localizedText: String {
        get {
            return text ?? ""
        }
        set {
            #if TARGET_INTERFACE_BUILDER
                var bundle = NSBundle(forClass: type(of: self))
                text = bundle.localizedStringForKey(newValue, value: "", table: nil)
            #else
                text = newValue.localized
            #endif
        }
    }
}
