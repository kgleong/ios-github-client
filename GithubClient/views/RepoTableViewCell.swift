//
//  RepoTableViewCell.swift
//  GithubClient
//
//  Created by Kevin Leong on 10/30/16.
//  Copyright © 2016 Orangemako. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
