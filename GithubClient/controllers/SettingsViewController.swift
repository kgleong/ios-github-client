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
    
    let sectionHeaderTextList = ["Rating", "Language"]
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderTextList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaderTextList[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsMinStarCountTableViewCell") as! SettingsMinStarCountTableViewCell
        
        return cell
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
}
