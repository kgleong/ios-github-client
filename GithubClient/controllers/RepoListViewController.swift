//
//  RepoListViewController.swift
//  GithubClient
//
//  Created by Kevin Leong on 10/30/16.
//  Copyright © 2016 Orangemako. All rights reserved.
//

import UIKit
import Alamofire
import AFNetworking

class RepoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    let searchBarPlaceholder = "Enter keywords"
    let navigationTitle = "Repos"
    let settingsSegueId = "com.orangemako.GithubClient.settingsSegue"

    @IBOutlet weak var tableView: UITableView!
    
    var searchTerms = [String]()
    var rawQueryParams = [[String: String]]()
    
    var searchBar = UISearchBar()
    var settingsViewController: SettingsViewController?

    // Infinite Scroll
    var currentPage = 1
    var isFetchingRepos = false
    var allReposFetched = false

    var loadingView: CustomNotificationView?

    // All fetched repos
    var repoList = [GithubRepo]()

    // Repos displayed in the table view.
    var displayRepoList = [GithubRepo]()

    var refreshControl = UIRefreshControl()

    // MARK: - ViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        refreshRepos()
    }
    
    // MARK: - Setup Views

    private func setupViews() {
        title = navigationTitle
        
        setupTableView()
        setupLoadingView()
        setupSearchBar()
        setupNavigationBar()
        setupSettings()
    }

    private func setupLoadingView() {
        loadingView = CustomNotificationView(parentView: self.view)
        loadingView?.title = "Loading"
        loadingView?.showSpinner = true
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.allowsSelection = false
        tableView.backgroundColor = UIColor.clear

        if let backgroundImage = UIImage(named: "blue-tiles") {
            view.backgroundColor = UIColor(patternImage: backgroundImage)
        }

        automaticallyAdjustsScrollViewInsets = false

        /*
            A UIRefreshControl sends a `valueChanged` event to signal
            when a refresh should occur.
        */
        refreshControl.addTarget(self, action: #selector(RepoListViewController.refreshRepos), for: .valueChanged)
        tableView.addSubview(refreshControl)
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
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

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
        return displayRepoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoTableViewCell") as! RepoTableViewCell
        cell.backgroundColor = UIColor.clear

        // Avoids index out of bounds errors when the displayed list is empty
        guard !displayRepoList.isEmpty else {
            return cell
        }

        populateRepoCell(cell: cell, repo: displayRepoList[indexPath.row])

        // Infinite scroll
        if(indexPath.row == repoList.count - 1 && indexPath.row != 0) {
            currentPage += 1
            getRepos()
        }

        return cell
    }

    private func populateRepoCell(cell: RepoTableViewCell, repo: GithubRepo) {
        cell.repoNameLabel.text = repo.name
        cell.ownerNameLabel.text = repo.ownerLoginName

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        if let ownerAvatarUrl = repo.avatarUrl {
            if let imageUrl = URL(string: ownerAvatarUrl) {
                cell.ownerAvatarImage.setImageWith(imageUrl)
            }
        }

        if let ownerType = repo.ownerType {
            cell.ownerTypeLabel.text = ownerType
        }

        if let starCount = repo.starCount {
            cell.starCountLabel.text = numberFormatter.string(from: NSNumber(value: starCount))
        }

        if let watcherCount = repo.watcherCount {
            cell.watcherCountLabel.text = numberFormatter.string(from: NSNumber(value: watcherCount))
        }

        if let forkCount = repo.forkCount {
            cell.forkCountLabel.text = numberFormatter.string(from: NSNumber(value: forkCount))
        }
    }
    
    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard (searchText.characters.count > 0) else {
            resetDisplayedRepos()
            return
        }

        do {
            displayRepoList = try repoList.filter() {
                (repo: GithubRepo) throws -> Bool
                in
                let regex = try NSRegularExpression(pattern: "\(searchText)", options: [NSRegularExpression.Options.caseInsensitive])

                guard let name = repo.name else {
                    return false
                }

                // Options: NSRegularExpression.MatchingOptions
                let numMatches = regex.numberOfMatches(in: name, options: [], range: NSRange(location: 0, length: name.characters.count))

                if(numMatches > 0) {
                    return true
                }
                else {
                    return false
                }
            }
        }
        catch {
            // NSRegularExpression error
            print("\(error)")
        }
        tableView.reloadData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false

        if searchTerms.isEmpty {
            resetDisplayedRepos()
        }
        else {
            refreshReposAfterSearch()
        }

        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text {
            if searchBarText.characters.count > 0 {
                searchTerms = searchBarText.components(separatedBy: " ")

                refreshRepos()
            }
            else {
                refreshReposAfterSearch()
            }
        }
    }

    // If a search was performed and then cleared, 
    // refetch repos using user preferences.
    func refreshReposAfterSearch() {
        if !searchTerms.isEmpty {
            searchTerms.removeAll()
            refreshRepos()
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
                // Only add language filters if the language filter toggle is enabled.
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

    @objc private func refreshRepos() {
        // Clear repos
        repoList.removeAll()
        displayRepoList = repoList

        // Reset current page
        currentPage = 1
        allReposFetched = false

        // Fetch repos
        getRepos()
    }

    // Resets the display repo list to show all
    // the fetched repos in the table view.
    private func resetDisplayedRepos() {
        displayRepoList = repoList
        tableView.reloadData()
    }
    
    private func getRepos() {
        // Don't fetch repos if currently fetching or 
        // if all repos have already been fetched.
        guard !isFetchingRepos && !allReposFetched else {
            return
        }

        loadPreferencesIntoQueryMap()

        searchRepos(searchTerms: searchTerms, rawQueryParams: rawQueryParams)
    }
    
    private func searchRepos(searchTerms: [String]?, rawQueryParams: [[String: String]]?) {
        if let url = GithubClient.createSearchReposUrl(searchTerms: searchTerms, rawQueryParams: rawQueryParams, sort: nil, page: currentPage) {
            GithubClient.logRequest(url: url)

            isFetchingRepos = true
            loadingView?.displayNotification(shouldFade: false, onComplete: nil)

            Alamofire.request(url).responseJSON() {
                // NSHTTPURLResponse object
                response in

                /*
                 response.result is an enum, with two cases, .success or .failure
                 
                 values can be extracted by passing in a constant ref for each expected
                 input.
                 
                 E.g., .success(let value)
                */
                switch response.result {
                case .success:
                    // response.result.value is a [String: Any] object
                    if let itemsResponse = (response.result.value as? [String: Any])?["items"] as? [[String: Any]] {
                        if(itemsResponse.isEmpty) {
                            self.allReposFetched = true
                        }

                        for item in itemsResponse {
                            let repo = GithubRepo(responseMap: item)
                            self.repoList.append(repo)
                        }
                    }

                    self.isFetchingRepos = false
                    self.loadingView?.hideNotification()

                    self.resetDisplayedRepos()

                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }

                case .failure:
                    let alertController = UIAlertController(title: "Network error", message: "Could not fetch repositorie", preferredStyle: UIAlertControllerStyle.alert)

                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))

                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
