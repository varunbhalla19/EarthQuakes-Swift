//
//  CacheEntry.swift
//  Earthquakes-iOS
//
//  Created by varunbhalla19 on 21/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation

enum CacheEntry {
    case inProgress(Task<QuakeLocation, Error>)
    case location(QuakeLocation)
}

final class CacheEntryObject {
    let entry: CacheEntry
    init(entry: CacheEntry) { self.entry = entry }
}


extension NSCache where KeyType == NSString, ObjectType == CacheEntryObject {
    subscript(_ url: URL) -> CacheEntry? {
        get {
            let key = url.absoluteString as NSString
            let value = object(forKey: key)
            return value?.entry
        }
        set {
            let key = url.absoluteString as NSString
            if let newValue {
                let entry = CacheEntryObject(entry: newValue)
                setObject(entry, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
}
