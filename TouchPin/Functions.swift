//
//  Functions.swift
//  TouchPin
//
//  Created by Maximo Ernesto Beux Sepulveda on 8/28/16.
//  Copyright © 2016 mebapps. All rights reserved.
//

import Foundation

func localizedStringFor(key: String, comment: String) -> String {
    
    let name = "PasscodeLock"
    let bundle = bundleForResource(name, ofType: "strings")
    
    return NSLocalizedString(key, tableName: name, bundle: bundle, comment: comment)
}

func bundleForResource(name: String, ofType type: String) -> NSBundle {
    
    if(NSBundle.mainBundle().pathForResource(name, ofType: type) != nil) {
        return NSBundle.mainBundle()
    }
    
    return NSBundle(forClass: PasscodeLock.self)
}
