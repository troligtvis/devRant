//
//  RantImage.swift
//  devRant_swift
//
//  Created by Kj Drougge on 2017-01-19.
//  Copyright © 2017 Code Fork. All rights reserved.
//

import Foundation

struct RantImage {
    let url: String
    let width: Int
    let height: Int
    
    init(json: JSON){
        self.url = json["url"] as! String
        self.width = json["width"] as! Int
        self.height = json["height"] as! Int
    }
}
