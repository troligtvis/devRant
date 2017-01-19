//
//  UserAvatar.swift
//  devRant_swift
//
//  Created by Kj Drougge on 2017-01-19.
//  Copyright © 2017 Code Fork. All rights reserved.
//

import Foundation

final class UserAvatar {
    let b: String
    let i: String
    
    init(json: JSON) {
        self.b = json["b"] as? String ?? ""
        self.i = json["i"] as? String ?? ""
    }
}
