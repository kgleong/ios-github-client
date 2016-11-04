//
//  SettingsLanguageToggleTableViewCell.swift
//  GithubClient
//
//  Created by Kevin Leong on 11/4/16.
//  Copyright © 2016 Orangemako. All rights reserved.
//

import UIKit

class SettingsLanguageToggleTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageSwitch: UISwitch!

    let descriptionText = "Filter by language"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        descriptionLabel.text = descriptionText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
