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

    static let sortQueryParamKey = "sort"
    static let sortSeparator = "="

    static let pageQueryParamKey = "page"
    
    // Search API query param keys
    static let stars = "stars"
    static let language = "language"

    static let queryParamKey = "key"
    static let queryParamValue = "value"
    
    // MARK: - Build Request
    
    /**
        Sample search request:
        `https://api.github.com/search/repositories?q=ios user:kgleong language:swift stars:<=50`
    */
    class func createSearchReposUrl(searchTerms: [String]?, rawQueryParams: [[String: String]]?, sort: String?, page: Int) -> URL? {
        var queryStrings = [String]()

        // Add search terms
        if let searchTerms = searchTerms {
            if !searchTerms.isEmpty {
                queryStrings.append(contentsOf: searchTerms)
            }
        }

        if let rawQueryParams = rawQueryParams {
            for param in rawQueryParams {
                guard let key = param[queryParamKey], let value = param[queryParamValue] else {
                    continue
                }
                if key == GithubClient.stars {
                    queryStrings.append("\(key):>=\(value)")
                }
                else {
                    queryStrings.append("\(key):\(value)")
                }
            }
        }
        
        var queryItems = [URLQueryItem]()

        // Sort by
        if let sort = sort {
            queryItems.append(
                URLQueryItem(name: sortQueryParamKey, value: sort)
            )
        }
        else {
            // Default to DESC star sort
            queryItems.append(
                URLQueryItem(name: sortQueryParamKey, value: stars)
            )
        }

        queryItems.append(URLQueryItem(name: pageQueryParamKey, value: String(page)))
        
        if queryStrings.isEmpty {
            // Default to high star count
            queryItems.append(
                URLQueryItem(
                    name: searchQueryParamKey,
                    value: "\(stars):>10000"
                )
            )
        }
        else {
            queryItems.append(
                URLQueryItem(
                    name: searchQueryParamKey,
                    value: queryStrings.joined(separator: querySeparator)
                )
            )
        }
        
        return createUrl(path: searchReposPath, queryParams: queryItems)
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
