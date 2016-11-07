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
    var rawQueryParams = [[String: String]]()
    
    var searchBar = UISearchBar()
    var settingsViewController: SettingsViewController?
    
    var repoList = [GithubRepo]()

    // MARK: - ViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        repoList.removeAll()
        getRepos()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoTableViewCell") as! RepoTableViewCell

        cell.nameLabel.text = repoList[indexPath.row].name

        return cell
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
                searchTerms = searchBarText.components(separatedBy: " ")
            }
        }
    }

    // MARK: - User filter preferences

    private func loadPreferencesIntoQueryMap() {
        rawQueryParams.removeAll()

        let preferences = UserDefaults.standard

        if let minStars = preferences.value(forKey: SettingsViewController.minStarsKey) as? Int {
            rawQueryParams.append(["\(GithubClient.stars)": ">=\(minStars)"])
        }

        if let searchByLanguageEnabled = preferences.value(forKey: SettingsViewController.searchByLanguageEnabledKey) as? Bool {
            if(searchByLanguageEnabled) {
                if let languages = preferences.value(forKey: SettingsViewController.selectedLanguagesKey) as? [String] {
                    for language in languages {
                        rawQueryParams.append(
                            [
                                "\(GithubClient.queryParamKey)": "\(GithubClient.language)",
                                "\(GithubClient.queryParamValue)": "\(language)",
                            ]
                        )
                    }
                }
            }
        }

    }
    
    // MARK: - Search Repos
    
    private func getRepos() {
        loadPreferencesIntoQueryMap()

        if !searchTerms.isEmpty || !rawQueryParams.isEmpty {
            searchRepos(searchTerms: searchTerms, rawQueryParams: rawQueryParams)
        }
    }
    
    private func searchRepos(searchTerms: [String]?, rawQueryParams: [[String: String]]?) {
        if let url = GithubClient.createSearchReposUrl(searchTerms: searchTerms, rawQueryParams: rawQueryParams, sort: nil) {
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

                self.tableView.reloadData()
            }
        }
    }
}
