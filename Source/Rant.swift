//
//  Rant.swift
//  devRant_swift
//
//  Created by Kj Drougge on 2017-01-19.
//  Copyright © 2017 Code Fork. All rights reserved.
//

import Foundation

final class Rant {
    let id: Int?
    let text: String?
    let numberOfUpvotes: Int?
    let numberOfDownvotes: Int?
    let score: Int?
    let createdTime: Int?
    let attachedImage: RantImage?
    let numberOfComments: Int?
    let tags: [String]?
    let voteState: Int?
    let userId: Int?
    let userName: String?
    let userScore: Int?
    let edited: Bool?
    
    var comments = [Comment]()
    
    init(json: JSON) {
        self.id = json["id"] as? Int
        self.text = json["text"] as? String
        self.numberOfUpvotes = json["num_upvotes"] as? Int
        self.numberOfDownvotes = json["num_downvotes"] as? Int
        self.score = json["score"] as? Int
        self.createdTime = json["created_time"] as? Int
        if let attachedImageJSON = json["attached_image"] as? JSON {
            self.attachedImage = RantImage(json: attachedImageJSON)
        } else {
            self.attachedImage = nil
        }
        
        self.numberOfComments = json["num_comments"] as? Int
        
        self.tags = nil
        self.voteState = json["vote_state"] as? Int
        self.userId = json["user_id"] as? Int
        self.userName = json["user_username"] as? String
        self.userScore = json["user_score"] as? Int
        self.edited = json["edited"] as? Bool
    }
}
