//
//  RepoListViewController.swift
//  GithubClient
//
//  Created by Kevin Leong on 10/30/16.
//  Copyright © 2016 Orangemako. All rights reserved.
//

import UIKit
import Alamofire

class RepoListViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    let controllerTitle = "Repos"

    @IBOutlet weak var tableView: UITableView!
    
    var searchTerms = [String]()
    var queryMap = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = controllerTitle
        
        // TODO: remove. for development purposes only.
        searchTerms.append("omako")
        
        getRepos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Search Repos
    
    private func getRepos() {
        if !searchTerms.isEmpty || !queryMap.isEmpty {
            searchRepos(searchTerms: searchTerms, queryMap: queryMap)
        }
    }
    
    private func searchRepos(searchTerms: [String]?, queryMap: [String: String]?) {
        if let url = GithubClient.createSearchReposUrl(searchTerms: searchTerms, queryMap: queryMap) {
            GithubClient.logRequest(url: url)

            Alamofire.request(url).responseJSON() {
                response in

                // Parse
            }
        }
    }
}
