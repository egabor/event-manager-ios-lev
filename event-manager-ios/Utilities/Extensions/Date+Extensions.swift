//
//  Date+Extensions.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

import Foundation

extension Date {
    func toString(format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let string = dateFormatter.string(from: self)
        return string
    }
    
    func longDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let string = dateFormatter.string(from: self)
        return string
    }
}
