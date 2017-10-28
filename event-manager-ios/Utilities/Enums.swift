//
//  Enums.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

enum EventType: String {
    case music, cinema, standUp, other, unknown
}

enum PlaceType: String {
    case stage, wc, luggage, bicycle, information, shower, camping, adrenaline, coffee, alcohol, taxi, tobacco, water, food, ticket, atm, metapay, firstAid, electric, carPark, interestingPlace, wasteCollector, other, unknown
}

enum EventGroupOption: Int {
    case alphabetical, places, dates, favorites, live
}
