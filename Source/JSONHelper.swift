//
//  JSONHelper.swift
//  devRant_swift
//
//  Created by Kj Drougge on 2017-01-19.
//  Copyright © 2017 Code Fork. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]
struct JSONHelper {
    static func getJSON(from data: Data?) -> JSON? {
        do {
            guard let data = data else { return nil }
            let json = try JSONSerialization.jsonObject(with: data) as? JSON
            return json
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
