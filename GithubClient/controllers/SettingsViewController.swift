//
//  SettingsViewController.swift
//  GithubClient
//
//  Created by Kevin Leong on 10/30/16.
//  Copyright © 2016 Orangemako. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    public static let storyboardId = "com.orangemako.GithubClient.settingsViewController"
    public static let navigationTitle = "Settings"
    
    let saveButtonTitle = "Save"
    let cancelButtonTitle = "Cancel"
    
    var saveButtonItem: UIBarButtonItem?
    var cancelButtonItem: UIBarButtonItem?
    
    static let ratingSectionTitle = "Rating"
    static let languageSectionTitle = "Language"
    static let sectionHeaderTextList = [ratingSectionTitle, languageSectionTitle]
    static let languages = ["Swift", "Java", "Ruby", "Go", "Python", "C", "C++"]
    
    var displayedLanguages = [String]()
    var languageToggleIsOn = true
    
    @IBOutlet weak var tableView: UITableView!
    
    override func loadView() {
        if languageToggleIsOn {
            displayedLanguages = SettingsViewController.languages
        }
        
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = SettingsViewController.navigationTitle
        
        setupViews()
    }

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
            cell = tableView.dequeueReusableCell(withIdentifier: "SettingsMinStarCountTableViewCell")
        }
        else {
            if(indexPath.row == 0) {
                let languageToggleCell = tableView.dequeueReusableCell(withIdentifier: "SettingsLanguageToggleTableViewCell") as! SettingsLanguageToggleTableViewCell
                languageToggleCell.languageSwitch.addTarget(self, action: #selector(SettingsViewController.onLanguageToggle(sender:)), for: UIControlEvents.touchUpInside)
                
                cell = languageToggleCell
            }
            else {
                let languageCell = tableView.dequeueReusableCell(withIdentifier: "SettingsLanguageTableViewCell") as! SettingsLanguageTableViewCell
                languageCell.languageLabel.text = displayedLanguages[indexPath.row - 1]
                
                cell = languageCell
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
    
    // MARK: - Target Actions
    
    @objc private func saveSettings() {
        print("saving settings")
    }
    
    @objc private func cancelSettings() {
        print("no changes made to settings")
        
        // Need to assign return value to avoid warning
        // http://stackoverflow.com/questions/37843049/xcode-8-swift-3-expression-of-type-uiviewcontroller-is-unused-warning
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc private func onLanguageToggle(sender: UISwitch) {
        if sender.isOn {
            displayedLanguages = SettingsViewController.languages
        }
        else {
            displayedLanguages.removeAll()
        }
        tableView.reloadData()
    }
}
