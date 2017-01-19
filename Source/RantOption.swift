//
//  RantOption.swift
//  devRant_swift
//
//  Created by Kj Drougge on 2017-01-19.
//  Copyright © 2017 Code Fork. All rights reserved.
//

import Foundation

enum SortOption: String {
    case algo = "algo"
    case recent = "recent"
    case top = "top"
}

struct RantOption {
    /// Optional. The type of rants to be fetched. Must be algo, recent or top. When omitted, it defaults to algo
    let sort: SortOption
    /// Optional. The amount of rants to be fetched. When omitted, it defaults to 50
    let limit: Int
    /// Optional. The amount of rants to be skipped. When omitted, it defaults to 0
    let skip: Int
    
    init(sort: SortOption = .algo, limit: Int = 50, skip: Int = 0) {
        self.sort = sort
        self.limit = limit
        self.skip = skip
    }
}

extension RantOption {
    func getPath() -> String {
        return "&sort=\(sort)&limit=\(limit)&skip=\(skip)"
    }
}
