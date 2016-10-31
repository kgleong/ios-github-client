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
    let searchBarPlaceholder = "Enter keywords"
    let navigationTitle = "Repos"
    let settingsSegueId = "com.orangemako.GithubClient.settingsSegue"

    @IBOutlet weak var tableView: UITableView!
    
    var searchTerms = [String]()
    var queryMap = [String: String]()
    
    var searchBar = UISearchBar()
    var settingsViewController: SettingsViewController?
    
    var repoList = [GithubRepo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        // TODO: remove. for development purposes only.
        searchTerms.append("omako")

        getRepos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        title = navigationTitle
        
        setupSearchBar()
        setupNavigationBar()
        setupSettings()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        //tableView.dataSource = repoList
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = searchBarPlaceholder
    }
    
    private func setupSettings() {
        settingsViewController =
            UIStoryboard(
                name: "Main",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: SettingsViewController.storyboardId
            ) as? SettingsViewController
    }
    
    private func setupNavigationBar() {
        let topNavigationItem = navigationController?.navigationBar.topItem
        
        topNavigationItem?.leftBarButtonItem =
            UIBarButtonItem(
                title: SettingsViewController.navigationTitle,
                style: .plain,
                target: self,
                action: #selector(RepoListViewController.displaySettings)
            )
        
        topNavigationItem?.titleView = searchBar
    }
    
    // MARK: UI Target Actions
    
    @objc private func displaySettings() {
        if let settingsViewController = settingsViewController {
            navigationController?.pushViewController(settingsViewController, animated: true)
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text {
            if searchBarText.characters.count > 0 {
                // TODO: Fetch repos by keyword
            }
        }
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
                // NSHTTPURLResponse object
                response in

                // response.result.value is a [String: Any] object
                if let itemsResponse = (response.result.value as? [String: Any])?["items"] as? [[String: Any]] {
                    for item in itemsResponse {
                        let repo = GithubRepo(responseMap: item)
                        self.repoList.append(repo)
                    }
                }
            }
        }
    }
}
