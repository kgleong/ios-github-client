//
//  SettingsViewController.swift
//  GithubClient
//
//  Created by Kevin Leong on 10/30/16.
//  Copyright © 2016 Orangemako. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SettingsMinStartCountTableViewCellDelegate {
    public static let storyboardId = "com.orangemako.GithubClient.settingsViewController"
    public static let navigationTitle = "Filters"
    
    let saveButtonTitle = "Save"
    let cancelButtonTitle = "Cancel"
    
    var saveButtonItem: UIBarButtonItem?
    var cancelButtonItem: UIBarButtonItem?
    
    static let ratingSectionTitle = "Rating"
    static let languageSectionTitle = "Language"
    static let sectionHeaderTextList = [ratingSectionTitle, languageSectionTitle]
    static let languages: Set<String> = ["Swift", "Java", "Ruby", "Go", "Python", "C", "C++"]
    
    var displayedLanguages = [String]()
    
    // User preferences
    let searchByLanguageEnabledKey = "searchByLanguage"
    let selectedLanguagesKey = "selectedLanguages"
    let minStarsKey = "minStars"
    
    var selectedLanguages: Set<String>?
    var searchByLanguageEnabled: Bool?
    var minStars: Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = SettingsViewController.navigationTitle
        
        setupViews()
        loadPreferences()

        if let searchByLanguageEnabled = searchByLanguageEnabled {
            if(searchByLanguageEnabled) {
                displayedLanguages = Array(SettingsViewController.languages)
            }
        }
    }

    // MARK: User Preferences
    
    private func loadPreferences() {
        let userDefaults = UserDefaults.standard
        
        minStars = userDefaults.value(forKey: minStarsKey) as? Int ?? 0
        
        // Sets are not eligible for storage in UserDefaults
        let selectedLanguagesArray = userDefaults.value(forKey: selectedLanguagesKey) as? [String] ?? [String]()
        selectedLanguages = Set(selectedLanguagesArray)
        
        searchByLanguageEnabled = userDefaults.value(forKey: searchByLanguageEnabledKey) as? Bool ?? false
    }
    
    private func savePreferences() {
        let userDefaults = UserDefaults.standard

        userDefaults.set(minStars, forKey: minStarsKey)
        userDefaults.set(Array(selectedLanguages!), forKey: selectedLanguagesKey)
        userDefaults.set(searchByLanguageEnabled, forKey: searchByLanguageEnabledKey)
    }
    
    // MARK: Setup Views
    
    private func setupViews() {
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        saveButtonItem = UIBarButtonItem(
            title: saveButtonTitle,
            style: .plain,
            target: self,
            action: #selector(SettingsViewController.saveSettings)
        )
        
        cancelButtonItem = UIBarButtonItem(
            title: cancelButtonTitle,
            style: .plain,
            target: self,
            action: #selector(SettingsViewController.cancelSettings)
        )
        
        navigationItem.leftBarButtonItem = saveButtonItem
        navigationItem.rightBarButtonItem = cancelButtonItem
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK: - UITableViewDelegate Protocol

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsViewController.sectionHeaderTextList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingsViewController.sectionHeaderTextList[section]
    }
    
    /*
        Required protocol method.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows = 1
        
        if(SettingsViewController.sectionHeaderTextList[section] == SettingsViewController.languageSectionTitle) {
            numRows = displayedLanguages.count + 1
        }
        
        return numRows
    }
    
    /*
        Required protocol method.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if(SettingsViewController.sectionHeaderTextList[indexPath.section] == SettingsViewController.ratingSectionTitle) {
            let minStarsCell = tableView.dequeueReusableCell(withIdentifier: "SettingsMinStarCountTableViewCell") as! SettingsMinStarCountTableViewCell
            minStarsCell.savedMinStars = minStars
            minStarsCell.delegate = self
            
            if(minStarsCell.desiredMinStars == nil) {
                minStarsCell.setMinStars(count: minStars!)
            }
            
            cell = minStarsCell
        }
        else {
            if(indexPath.row == 0) {
                // Filter by language cell.
                let languageToggleCell = tableView.dequeueReusableCell(withIdentifier: "SettingsLanguageToggleTableViewCell") as! SettingsLanguageToggleTableViewCell
                
                // Trigger showing or hiding of languages and setting the preference value.
                languageToggleCell.languageSwitch.addTarget(self, action: #selector(SettingsViewController.onLanguageToggle(sender:)), for: UIControlEvents.touchUpInside)
                
                languageToggleCell.languageSwitch.setOn(searchByLanguageEnabled!, animated: false)
                
                //showOrHideLanguages(showLanguages: searchByLanguageEnabled!)
                
                cell = languageToggleCell
            }
            else {
                // Specific language cells.
                let languageCell =
                    tableView.dequeueReusableCell(
                        withIdentifier: "SettingsLanguageTableViewCell"
                    ) as! SettingsLanguageTableViewCell
                
                let language = displayedLanguages[indexPath.row - 1]
                languageCell.languageLabel.text = language
            
                if let selectedLanguages = selectedLanguages {
                    if(selectedLanguages.contains(language)) {
                        languageCell.accessoryType = UITableViewCellAccessoryType.checkmark
                    }
                    else {
                        languageCell.accessoryType = UITableViewCellAccessoryType.none
                    }
                }
                
                if indexPath.row % 2 == 1 {
                    // Light gray
                    languageCell.backgroundColor =
                        UIColor(
                            red: 0.95,
                            green: 0.95,
                            blue: 0.95,
                            alpha: 1.0
                        )
                }

                cell = languageCell
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check or un-check languages
        if let cell = tableView.cellForRow(at: indexPath) as? SettingsLanguageTableViewCell {
            let language = cell.languageLabel.text
            
            if (cell.accessoryType == UITableViewCellAccessoryType.checkmark) {
                cell.accessoryType = UITableViewCellAccessoryType.none
                _ = selectedLanguages?.remove(language!)
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                selectedLanguages?.insert(language!)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Target Actions
    
    @objc private func saveSettings() {
        print("saving settings")
        
        savePreferences()
        dismiss()
    }
    
    @objc private func cancelSettings() {
        print("no changes made to settings")
        dismiss()
    }
    
    @objc private func onLanguageToggle(sender: UISwitch) {
        showOrHideLanguages(showLanguages: sender.isOn)
    }
    
    private func showOrHideLanguages(showLanguages: Bool) {
        var indexPaths = [IndexPath]()
        
        for i in 1...SettingsViewController.languages.count {
            indexPaths.append(IndexPath(row: i, section: 1))
        }
        
        if showLanguages {
            // Show languages
            displayedLanguages = Array(SettingsViewController.languages)
            tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.bottom)
            
            // Set preference
            searchByLanguageEnabled = true
        }
        else {
            // Hide languages
            displayedLanguages.removeAll()
            
            if(tableView.numberOfRows(inSection: 1) > 1) {
                tableView.deleteRows(at: indexPaths, with: UITableViewRowAnimation.top)
            }
            else {
                tableView.reloadData()
            }
            
            // Set preference
            searchByLanguageEnabled = false
        }
    }
    
    // MARK: - SettingsMinStartCountTableViewCellDelegate
    
    func onMinStarCountChange(sender: SettingsMinStarCountTableViewCell) {
        minStars = sender.desiredMinStars
    }
    
    // MARK: - Navigation
    
    private func dismiss() {
        // Need to assign return value to avoid warning
        // http://stackoverflow.com/questions/37843049/xcode-8-swift-3-expression-of-type-uiviewcontroller-is-unused-warning
        _ = navigationController?.popViewController(animated: true)
    }
}
