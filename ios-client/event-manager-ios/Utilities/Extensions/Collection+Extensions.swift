//
//  Collection+Extensions.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 20..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

extension Collection {

    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
