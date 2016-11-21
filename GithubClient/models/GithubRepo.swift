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
    var forkCount: Int?
    var watcherCount: Int?
    var starCount: Int?
    var issuesCount: Int?
    var language: String?
    var repoDescription: String?

    var avatarUrl: String?
    var ownerType: String?
    var ownerLoginName: String?
    var repoUrl: String?
    
    init(responseMap: [String: Any]?) {
        if let responseMap = responseMap {
            // Repo information
            name = responseMap["name"] as? String
            score = responseMap["score"] as? Double
            forkCount = responseMap["forks_count"] as? Int
            watcherCount = responseMap["watchers_count"] as? Int
            starCount = responseMap["stargazers_count"] as? Int
            issuesCount = responseMap["open_issues_count"] as? Int
            language = responseMap["language"] as? String
            repoDescription = responseMap["description"] as? String
            repoUrl = responseMap["html_url"] as? String
            
            // User information
            if let ownerMap = responseMap["owner"] as?  [String: Any] {
                avatarUrl = ownerMap["avatar_url"] as? String
                ownerType = ownerMap["type"] as? String
                ownerLoginName = ownerMap["login"] as? String
            }
        }
    }
}
