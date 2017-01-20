//
//  Router.swift
//  devRant_swift
//
//  Created by Kj Drougge on 2017-01-20.
//  Copyright © 2017 Code Fork. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum Router {
    static let root = "https://www.devrant.io/api"
    static let appId = 3
    
    case getId(for: String)
    case getRant(with: Int)
    case getRants(options: RantOption)
    case search(for: String)
    case getProfile(with: Int)
    
    func asURLRequest() -> URLRequest {
        let result: (path: String, method: HTTPMethod, parameters: JSON?) = {
            switch self {
            case .getId(let username):
                return ("/get-user-id?app=\(Router.appId)&username=\(username)", .get, nil)
            case .getRant(let id):
                return ("/devrant/rants/\(id)?app=\(Router.appId)", .get, nil)
            case .getRants(let options):
                return ("/devrant/rants?app=\(Router.appId)" + options.getPath(), .get, nil)
            case .search(let term):
                return ("/devrant/search?app=\(Router.appId)&term=\(term)", .get, nil)
            case .getProfile(let userId):
                return ("/users/\(userId)?app=\(Router.appId)", .get, nil)
            }
        }()
        
        let url = URL(string: Router.root + result.path)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = result.method.rawValue
        
        if let parameters = result.parameters {
            let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
}
