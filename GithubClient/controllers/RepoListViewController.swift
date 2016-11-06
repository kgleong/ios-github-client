//
//  RepoListViewController.swift
//  GithubClient
//
//  Created by Kevin Leong on 10/30/16.
//  Copyright © 2016 Orangemako. All rights reserved.
//

import UIKit
import Alamofire

class RepoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
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
        getRepos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        title = navigationTitle
        
        setupTableView()
        setupSearchBar()
        setupNavigationBar()
        setupSettings()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        automaticallyAdjustsScrollViewInsets = false
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
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(
                title: SettingsViewController.navigationTitle,
                style: .plain,
                target: self,
                action: #selector(RepoListViewController.displaySettings)
            )
        
        navigationItem.titleView = searchBar
    }
    
    // MARK: UI Target Actions
    
    @objc private func displaySettings() {
        if let settingsViewController = settingsViewController {
            settingsViewController.tableView?.reloadData()
            navigationController?.pushViewController(settingsViewController, animated: true)
        }
    }
    
    // MARK: - UITableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
        if let url = GithubClient.createSearchReposUrl(searchTerms: searchTerms, queryMap: queryMap, sort: nil) {
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
