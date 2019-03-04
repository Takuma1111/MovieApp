//
//  KeyManager.swift
//  MovieApp
//
//  Created by 村上拓麻 on 2019/03/04.
//  Copyright © 2019 村上拓麻. All rights reserved.
//

import Foundation
struct KeyManager {
    
    private let keyFilePath = Bundle.main.path(forResource: "apiKey", ofType: "plist")
    
    func getKeys() -> NSDictionary? {
        guard let keyFilePath = keyFilePath else {
            return nil
        }
        return NSDictionary(contentsOfFile: keyFilePath)
    }
    
    func getValue(key: String) -> AnyObject? {
        guard let keys = getKeys() else {
            return nil
        }
        return keys[key]! as AnyObject
    }
}
