//
//  Enums.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

enum EventType: String {
    case music, meetup, show, cinema, standUp, other, unknown
}

enum PlaceType: String {
    case club, stage, wc, luggage, bicycle, information, shower, camping, adrenaline, coffee, alcohol, taxi, tobacco, water, food, ticket, atm, metapay, firstAid, electric, carPark, interestingPlace, wasteCollector, other, unknown
}

enum EventGroupOption: Int {
    case alphabetical, places, days, months, years, favorites, live
}
