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
    
    
    fileprivate func task(with request: URLRequest, completion: @escaping (JSON?) -> Void) {
        defaultSession.dataTask(with: request, completionHandler: {
            data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let json = JSONHelper.getJSON(from: data) else {
                print("no json")
                completion(nil)
                return
            }
            
            completion(json)
        }).resume()
    }

    
    func getId(from username: String, completion: @escaping (Int?) -> Void) {
        task(with: Router.getId(for: username).asURLRequest(), completion: {
            json in
            
            guard let json = json else {
                completion(nil)
                return
            }
            
            guard let userId = json["user_id"] as? Int else {
                print("did not find user id")
                completion(nil)
                return
            }
            
            completion(userId)
        })
    }
    
    /// Retrieve a single rant from devRant. Use this method to retrieve a rant with its full text and comments.
    ///
    /// - Parameters:
    ///   - id: Int?
    ///   - completion: (Rant?) -> ()
    func getRant(_ id: Int?, completion: @escaping (Rant?) -> Void) {
        guard let id = id else {
            print("Could not find id")
            completion(nil)
            return
        }
        
        task(with: Router.getRant(with: id).asURLRequest(), completion: {
            json in
            
            guard let json = json else {
                completion(nil)
                return
            }
            
            let rant: Rant = Rant(json: json["rant"] as! JSON)
            let comments: [Comment] = (json["comments"] as! [JSON]).flatMap({ Comment(json: $0) })
            
            rant.comments = comments
            completion(rant)
        })
    }
    
    /// By providing a RantOption as an argument, it's possible to sort by 'algo', 'recent' and 'top' rants. As well as limiting and skipping the amount of rants to be fetched. Otherwise the default values will be used
    ///
    /// Default values:
    /// sort: 'algo', limit: 50, skip: 0
    ///
    /// - Parameters:
    ///   - options: (Optional) RantOption
    ///   - completion: ([Rant]?) -> ()
    func getRants(_ options: RantOption = RantOption(), completion: @escaping ([Rant]?) -> Void) {
        task(with: Router.getRants(options: options).asURLRequest(), completion: {
            json in
            
            guard let json = json else {
                completion(nil)
                return
            }
            
            guard let rantsJSON = json["rants"] as? [JSON] else {
                completion(nil)
                return
            }
            
            let rants: [Rant] = rantsJSON.flatMap({ Rant(json: $0) })
            completion(rants)
        })
    }
    
    
    /// Retrieve rants from devRant that match a specific search term.
    ///
    /// - Parameters:
    ///   - term: String search term
    ///   - completion: ([Rant]?) -> ()
    func search(for term: String, completion: @escaping ([Rant]?) -> Void) {
        task(with: Router.search(for: term).asURLRequest(), completion: {
            json in
            
            guard let json = json else {
                completion(nil)
                return
            }
            
            guard let rantsJSON = json["rants"] as? [JSON] else {
                completion(nil)
                return
            }
            
            let rants: [Rant] = rantsJSON.flatMap({ Rant(json: $0) })
            completion(rants)
        })
    }
    
    /// Retrieve the profile of a devRant user by username.
    ///
    /// - Parameters:
    ///   - username: String devRant username
    ///   - completion: (Profile?) -> ()
    func getProfile(for username: String, completion: @escaping (Profile?) -> Void){
        getId(from: username, completion: {
            userId in
            
            guard let userId = userId else {
                print("did not find user id")
                completion(nil)
                return
            }
            
            self.task(with: Router.getProfile(with: userId).asURLRequest(), completion: {
                json in
                
                guard let json = json else {
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
            })
        })
    }
}
