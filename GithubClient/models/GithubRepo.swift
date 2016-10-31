//
//  GithubRepo.swift
//  GithubClient
//
//  Created by Kevin Leong on 10/31/16.
//  Copyright © 2016 Orangemako. All rights reserved.
//

import Foundation

class GithubRepo {
    var name: String?
    var score: Double?
    var forks: Int?
    var watcherCount: Int?
    var starCount: Int?
    
    init(responseMap: [String: Any]?) {
        if let responseMap = responseMap {
            name = responseMap["name"] as? String
            score = responseMap["score"] as? Double
            forks = responseMap["forks"] as? Int
            watcherCount = responseMap["watchers_count"] as? Int
            starCount = responseMap["stargazers_count"] as? Int
        }
    }
}
