//
//  SettingsMinStarCountTableViewCell.swift
//  GithubClient
//
//  Created by Kevin Leong on 11/2/16.
//  Copyright © 2016 Orangemako. All rights reserved.
//

import UIKit

protocol SettingsMinStarCountTableViewCellDelegate: class {
    func onMinStarCountChange(sender: SettingsMinStarCountTableViewCell)
}

class SettingsMinStarCountTableViewCell: UITableViewCell {
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minStarCountLabel: UILabel!
    
    let descriptionText = "Min Stars"
    let maxMinStars = 5000
    
    weak var delegate: SettingsMinStarCountTableViewCellDelegate?
    
    var desiredMinStars: Int?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupViews()
    }

    // MARK: - View Setup

    private func setupViews() {
        descriptionLabel.text = descriptionText
        setMinStarCountLabel()

        slider.value = Float(displayStarCount()) / Float(maxMinStars)
    }

    private func setMinStarCountLabel() {
        minStarCountLabel.text = "\(displayStarCount())"
    }

    private func displayStarCount() -> Int {
        return desiredMinStars ?? 0
    }

    // MARK: - Target Actions
    
    @IBAction func onSliderChanged(_ sender: UISlider) {
        desiredMinStars = Int((sender.value * Float(maxMinStars)).rounded())
        setMinStarCountLabel()
        delegate?.onMinStarCountChange(sender: self)
    }

    // MARK: - External Modifiers

    func setMinStars(minStars: Int) {
        desiredMinStars = minStars
        slider.setValue(Float(minStars) / Float(maxMinStars), animated: true)
        setMinStarCountLabel()
    }
}
