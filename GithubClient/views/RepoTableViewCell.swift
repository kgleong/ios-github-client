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
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerAvatarImage: UIImageView!
    @IBOutlet weak var ownerContainer: UIView!
    @IBOutlet weak var ownerRepoDivider: UIView!
    @IBOutlet weak var ownerTypeLabel: UILabel!

    @IBOutlet weak var repoContainer: UIView!



    // Repo information
    // score = responseMap["score"] as? Double
    // forkCount = responseMap["forks_count"] as? Int
    // watcherCount = responseMap["watchers_count"] as? Int
    // starCount = responseMap["stargazers_count"] as? Int
    // issuesCount = responseMap["open_issues_count"] as? Int
    // language = responseMap["language"] as? String

    // avatarUrl = ownerMap["avatar_url"] as? String
    //   ownerType = ownerMap["type"] as? String


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
    }

    private func setupAvatarImage() {
        // Circular avatar image
        ownerAvatarImage.layer.cornerRadius = ownerAvatarImage.frame.width / 2
        ownerAvatarImage.clipsToBounds = true

        // Image border
        ownerAvatarImage.layer.borderWidth = 2.0
        ownerAvatarImage.layer.borderColor = UIColor.darkGray.cgColor
    }
}
