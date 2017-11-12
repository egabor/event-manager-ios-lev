//
//  Sequence+Extensions.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

public extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.append(element) {
                categories[key] = [element]
            }
        }
        return categories
    }
}

public extension Sequence where Iterator.Element: Equatable {
    var uniqueElements: [Iterator.Element] {
        return self.reduce([]) { uniqueElements, element in
            uniqueElements.contains(element)
                ? uniqueElements
                : uniqueElements + [element]
        }
    }
}
