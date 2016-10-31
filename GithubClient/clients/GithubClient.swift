//
//  GithubClient.swift
//  GithubClient
//
//  Created by Kevin Leong on 10/30/16.
//  Copyright © 2016 Orangemako. All rights reserved.
//

import Foundation

class GithubClient {
    // * https://api.github.com/search/repositories?q=rails activerecord user:muratguzel language:java language:javascript stars:>=50

    static let secureScheme = "https"
    static let githubHost = "api.github.com"
    static let searchReposPath = "/search/repositories"
    
    static let searchQueryParamKey = "q"
    static let querySeparator = " "
    
    // MARK: - Build Request
    
    /**
        Sample search request:
        `https://api.github.com/search/repositories?q=ios views user:kgleong language:swift language:objective-c stars:>=50`
    */
    class func createSearchReposUrl(searchTerms: [String]?, queryMap: [String: String]?) -> URL? {
        var queryStrings = [String]()
        
        if let searchTerms = searchTerms {
            queryStrings.append(contentsOf: searchTerms)
        }
        
        if let queryMap = queryMap {
            for (key, value) in queryMap {
                queryStrings.append("\(key):\(value)")
            }
        }

        let queryItem = URLQueryItem(
            name: searchQueryParamKey,
            value: queryStrings.joined(separator: querySeparator)
        )
        
        return createUrl(path: searchReposPath, queryParams: [queryItem])
    }
    
    class func createUrl(path: String, queryParams: [URLQueryItem]?) -> URL? {
        let urlComponents = NSURLComponents()
        
        urlComponents.scheme = secureScheme
        urlComponents.host = githubHost
        urlComponents.path = path
        urlComponents.queryItems = [URLQueryItem]()
        
        if let queryParams = queryParams {
            urlComponents.queryItems!.append(contentsOf: queryParams)
        }
        
        return urlComponents.url
    }
    
    // MARK: - Logging
    
    class func logRequest(url: URL) {
        print("Making request to: \(url)")
    }
}
