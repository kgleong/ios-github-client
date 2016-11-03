//
//  SettingsMinStarCountTableViewCell.swift
//  GithubClient
//
//  Created by Kevin Leong on 11/2/16.
//  Copyright © 2016 Orangemako. All rights reserved.
//

import UIKit

class SettingsMinStarCountTableViewCell: UITableViewCell {

    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minStarCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    private func setupViews() {
        descriptionLabel.text = "Min Stars"
        minStarCountLabel.text = "0"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
