//
//  Profile.swift
//  devRant_swift
//
//  Created by Kj Drougge on 2017-01-19.
//  Copyright © 2017 Code Fork. All rights reserved.
//

import Foundation

final class Profile {
    let id: Int
    let username: String?
    let score: Int?
    let github: String?
    let skills: String?
    let website: String?
    let createdTime: Int?
    let location: String?
    let about: String?
    let avatar: UserAvatar?
    
    var comments = [Comment]()
    var favorites = [Rant]()
    var rants = [Rant]()
    var upvoted = [Rant]()
    
    var commentsCount: Int!
    var favoritesCount: Int!
    var rantsCount: Int!
    var upvotedCount: Int!
    
    init(json: JSON, id: Int) {
        self.id = id
        self.username = json["username"] as? String
        self.score = json["score"] as? Int
        self.github = json["github"] as? String
        self.skills = json["skills"] as? String
        self.website = json["website"] as? String
        self.createdTime = json["created_time"] as? Int
        self.location = json["location"] as? String
        self.about = json["about"] as? String
        
        if let avatarJSON = json["avatar"] as? JSON {
            self.avatar = UserAvatar(json: avatarJSON)
        } else {
            self.avatar = nil
        }
    }
}
