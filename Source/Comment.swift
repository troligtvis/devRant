//
//  Comment.swift
//  devRant_swift
//
//  Created by Kj Drougge on 2017-01-19.
//  Copyright © 2017 Code Fork. All rights reserved.
//

import Foundation

final class Comment {
    let id: Int?
    let body: String?
    let createdTime: Int?
    let numberOfUpvotes: Int?
    let numberOfDownvotes: Int?
    let score: Int?
    let userAvatar: UserAvatar?
    let randId: Int?
    let userId: Int?
    let userScore: Int?
    let userName: String?
    let voteState: Int?
    
    init(json: JSON){
        self.id = json["id"] as? Int
        self.body = json["body"] as? String
        self.createdTime = json["created_time"] as? Int
        self.numberOfUpvotes = json["num_upvotes"] as? Int
        self.numberOfDownvotes = json["num_downvotes"] as? Int
        self.score = json["score"] as? Int
        if let userAvatarJSON = json["user_avatar"] as? JSON {
            self.userAvatar = UserAvatar(json: userAvatarJSON)
        } else {
            self.userAvatar = nil
        }
        
        self.randId = json["rand_id"] as? Int
        self.userId = json["user_id"] as? Int
        self.userScore = json["user_score"] as? Int
        self.userName = json["user_username"] as? String
        self.voteState = json["vote_state"] as? Int
    }
}
