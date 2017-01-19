//
//  DevRantApiManager.swift
//  devRant
//
//  Created by Kj Drougge on 2017-01-19.
//  Copyright © 2017 Code Fork. All rights reserved.
//

import Foundation

final class DevRantApiManager {
    static let shared = DevRantApiManager()
    
    fileprivate let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    fileprivate var dataTask: URLSessionDataTask?
    
    fileprivate let root = "https://www.devrant.io/api"
    fileprivate let appId = "3"
    
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    fileprivate func getRequest(for url: String, with method: HTTPMethod, andBody body: [String: String]? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string: root + url)!)
        request.httpMethod = method.rawValue
        
        if let body = body {
            let jsonData = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        
        return request
    }
    

    
    func getId(from username: String, completion: @escaping (Int?) -> Void) {
        let path = "?app=\(appId)&username=\(username)"
        let url = "/get-user-id" + path
        
        let request = getRequest(for: url, with: .get)
        defaultSession.dataTask(with: request, completionHandler: {
            data, response, error in
            
            if let error = error {
                print(#function, error.localizedDescription)
                completion(nil)
                return
            }
            guard let json = JSONHelper.getJSON(from: data) else {
                print("no json")
                completion(nil)
                return
            }
            
            print(json)
            guard let userId = json["user_id"] as? Int else {
                print("did not find user id")
                completion(nil)
                return
            }
            
            print(userId)
            completion(userId)
        }).resume()
    }
    
    func getRant(_ id: Int?, completion: @escaping (Rant?) -> Void) {
        guard let id = id else {
            print("Could not find id")
            completion(nil)
            return
        }
        
        let path = "/\(id)?app=\(appId)"
        let url = "/devrant/rants" + path
        
        let request = getRequest(for: url, with: .get)
        defaultSession.dataTask(with: request, completionHandler: {
            data, response, error in
            
            if let error = error {
                print(#function, error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let json = JSONHelper.getJSON(from: data) else {
                print("no json")
                completion(nil)
                return
            }
            
            let rant: Rant = Rant(json: json["rant"] as! JSON)
            let comments: [Comment] = (json["comments"] as! [JSON]).flatMap({ Comment(json: $0) })
            
            rant.comments = comments
            completion(rant)
        }).resume()
    }
    
    func getRants(_ options: RantOption = RantOption(), completion: @escaping ([Rant]?) -> Void) {
        let path = "?app=\(appId)" + options.getPath()
        let url = "/devrant/rants" + path
        let request = getRequest(for: url, with: .get)
        defaultSession.dataTask(with: request, completionHandler: {
            data, response, error in
            
            if let error = error {
                print(#function, error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let json = JSONHelper.getJSON(from: data) else {
                print("no json")
                completion(nil)
                return
            }
            
            guard let rantsJSON = json["rants"] as? [JSON] else {
                completion(nil)
                return
            }
            
            let rants: [Rant] = rantsJSON.flatMap({ Rant(json: $0) })
            completion(rants)
        }).resume()
    }
    
    func search(for term: String) {
        let path = "?app=\(appId)&term=\(term)"
        
    }
    
    
    /// Retrieve the profile of a devRant user by username.
    /// - parameter username: devRant username
    ///
    func getProfile(for username: String, completion: @escaping (Profile?) -> Void){
        getId(from: username, completion: {
            userId in
            
            guard let userId = userId else {
                print("did not find user id")
                completion(nil)
                return
            }
            
            let path = "?app=\(self.appId)"
            let url = "/users/\(userId)" + path
            let request = self.getRequest(for: url, with: .get)
            self.defaultSession.dataTask(with: request, completionHandler: {
                data, response, error in
                
                if let error = error {
                    print(#function, error.localizedDescription)
                    completion(nil)
                    return
                }
                
                guard let json = JSONHelper.getJSON(from: data) else {
                    print("no json")
                    completion(nil)
                    return
                }
                
                guard let profileJSON = json["profile"] as? JSON else {
                    completion(nil)
                    return
                }
                
                let profile = Profile(json: profileJSON, id: userId)
                
                let content = profileJSON["content"] as! JSON
                let innerContent = content["content"] as! JSON

                profile.comments = (innerContent["comments"] as! [JSON]).flatMap({ Comment(json: $0) })
                profile.favorites = (innerContent["favorites"] as! [JSON]).flatMap({ Rant(json: $0) })
                profile.rants = (innerContent["rants"] as! [JSON]).flatMap({ Rant(json: $0) })
                profile.upvoted = (innerContent["upvoted"] as! [JSON]).flatMap({ Rant(json: $0) })
                
                let counts = content["counts"] as! JSON
                profile.commentsCount = counts["comments"] as! Int
                profile.favoritesCount = counts["favorites"] as! Int
                profile.rantsCount = counts["rants"] as! Int
                profile.upvotedCount = counts["upvoted"] as! Int
                
                completion(profile)
            }).resume()
        })
    }
}
