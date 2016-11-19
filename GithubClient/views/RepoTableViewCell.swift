//
//  RepoTableViewCell.swift
//  GithubClient
//
//  Created by Kevin Leong on 10/30/16.
//  Copyright © 2016 Orangemako. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var watcherCountLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerAvatarImage: UIImageView!
    @IBOutlet weak var ownerContainer: UIView!
    @IBOutlet weak var ownerRepoDivider: UIView!
    @IBOutlet weak var ownerTypeLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var ownerInfoContainer: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var repoContainer: UIView!
    @IBOutlet weak var bodyView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Setup Views

    private func setupViews() {
        setupAvatarImage()
        setupShadowView()
        setupBodyView()
        setupOwnerViews()
        setupRepoInfoViews()
    }

    private func setupShadowView() {
        shadowView.backgroundColor = UIColor.clear
        shadowView.layer.shadowOpacity = 0.6
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 2.5 // blur
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3) // Spread
    }

    private func setupBodyView() {
        bodyView.layer.cornerRadius = 15.0
        bodyView.clipsToBounds = true
    }

    private func setupOwnerViews() {
        ownerNameLabel.textColor = UIColor.white
        ownerTypeLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
    }

    private func setupAvatarImage() {
        // Circular avatar image
        ownerAvatarImage.layer.cornerRadius = ownerAvatarImage.frame.width / 2
        ownerAvatarImage.clipsToBounds = true

        // Image border
        ownerAvatarImage.layer.borderWidth = 3.0
        ownerAvatarImage.layer.borderColor = UIColor.white.cgColor
    }

    private func setupRepoInfoViews() {
        descriptionLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.5, alpha: 1)

    }
}
