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

    @IBOutlet weak var tableView: UITableView!

    var saveButtonItem: UIBarButtonItem?
    var cancelButtonItem: UIBarButtonItem?

    let saveButtonTitle = "Save"
    let cancelButtonTitle = "Cancel"

    // Section header text
    let ratingSectionTitle = "Rating"
    let languageSectionTitle = "Language"
    lazy var sectionHeaderTextList: [String] = [self.ratingSectionTitle, self.languageSectionTitle]

    // Languages
    let defaultLanguages: Set<String> = [
        "Swift", "Java", "Ruby", "Go", "Python", "C", "C++"
    ]

    // Populates table view with languages.  The language enabled switch toggles this
    // value between all languages and an empty array.
    var displayedLanguages = [String]()

    // User preferences
    let searchByLanguageEnabledKey = "searchByLanguage"
    let selectedLanguagesKey = "selectedLanguages"
    let minStarsKey = "minStars"

    var selectedLanguages: Set<String>?
    var searchByLanguageEnabled: Bool?
    var minStars: Int?

    // MARK: UIViewController Overrides

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = SettingsViewController.navigationTitle

        loadPreferences()
        setupViews()
    }

    // MARK: - User preferences

    private func loadPreferences() {
        let userDefaults = UserDefaults.standard

        minStars = userDefaults.value(forKey: minStarsKey) as? Int ?? 0

        // Sets are not eligible for storage in UserDefaults
        let selectedLanguagesArray =
            userDefaults.value(forKey: selectedLanguagesKey) as? [String] ?? [String]()
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
        initializeViewData()
        setupTableView()
        setupNavigationBar()
    }

    private func initializeViewData() {
        // Populate languages to display if filter by language is enabled.
        if let searchByLanguageEnabled = searchByLanguageEnabled {
            if(searchByLanguageEnabled) {
                displayedLanguages = allLanguagesArray()
            }
        }
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

        // Remove padding around table view
        automaticallyAdjustsScrollViewInsets = false
    }

    // MARK: - UITableViewDelegate Protocol


    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderTextList.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaderTextList[section]
    }

    /*
        Required protocol method.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Min stars rating contains a single row
        var numRows = 1

        if(sectionHeaderTextList[section] == languageSectionTitle) {
            numRows = displayedLanguages.count + 1
        }

        return numRows
    }

    /*
        Required protocol method.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?

        // Min star rating
        if(sectionHeaderTextList[indexPath.section] == ratingSectionTitle) {
            let minStarsCell = tableView.dequeueReusableCell(withIdentifier: "SettingsMinStarCountTableViewCell") as! SettingsMinStarCountTableViewCell
            minStarsCell.savedMinStars = minStars
            minStarsCell.delegate = self

            if(minStarsCell.desiredMinStars == nil) {
                minStarsCell.setMinStars(count: minStars!)
            }

            cell = minStarsCell
        }
        // Languages filter
        else {
            if(indexPath.row == 0) {
                // Filter by language cell.
                let languageToggleCell = tableView.dequeueReusableCell(withIdentifier: "SettingsLanguageToggleTableViewCell") as! SettingsLanguageToggleTableViewCell

                // Trigger showing or hiding of languages and setting the preference value.
                languageToggleCell.languageSwitch.addTarget(self, action: #selector(SettingsViewController.onLanguageToggle(sender:)), for: UIControlEvents.touchUpInside)

                // Set the toggle to the correct value based on the user preference value
                languageToggleCell.languageSwitch.setOn(searchByLanguageEnabled!, animated: false)

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

    // MARK: - Convenience methods

    private func allLanguagesArray() -> [String] {
        return
            Array(
                defaultLanguages
            ).sorted() { (s1, s2) in s1 < s2 }
    }

    private func showOrHideLanguages(showLanguages: Bool) {
        // Create IndexPath objects for each row in the languages section.
        var indexPaths = [IndexPath]()

        guard let sectionIndex = sectionHeaderTextList.index(of: languageSectionTitle) else {
            print("Error: No language section")
            return
        }

        // Exclude the first row, which is the language filter toggle.
        for i in 1...allLanguagesArray().count {
            indexPaths.append(IndexPath(row: i, section: sectionIndex))
        }

        if showLanguages {
            // Show languages
            displayedLanguages = allLanguagesArray()
            tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.bottom)

            // Set preference
            searchByLanguageEnabled = true
        }
        else {
            // Hide languages
            displayedLanguages.removeAll()

            // Animate language hiding if languages are currently displayed.  Otherwise,
            // reload table view data without animating.
            if(tableView.numberOfRows(inSection: sectionIndex) > 1) {
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

    // When the min start count slider changes, update the min star count.
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
