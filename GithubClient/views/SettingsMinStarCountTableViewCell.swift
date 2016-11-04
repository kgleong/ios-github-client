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
    
    let descriptionText = "Min Stars"
    let maxMinStars = 5000
    
    var desiredMinStars = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    // MARK: - Target Actions
    
    @IBAction func onSliderChanged(_ sender: UISlider) {
        desiredMinStars = Int((sender.value * Float(maxMinStars)).rounded())
        setMinStarCountLabel()
    }
    
    // MARK: - View Setup
    
    private func setupViews() {
        descriptionLabel.text = descriptionText
        setMinStarCountLabel()
        slider.value = Float(desiredMinStars) / Float(maxMinStars)
    }
    
    private func setMinStarCountLabel() {
        minStarCountLabel.text = "\(desiredMinStars)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
