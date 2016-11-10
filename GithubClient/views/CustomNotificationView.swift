//
//  CustomNotificationView.swift
//  GithubClient
//
//  Created by Kevin Leong on 11/10/16.
//  Copyright © 2016 Orangemako. All rights reserved.
//

import UIKit

class CustomNotificationView: UIView {
    static var placeholderFrame = CGRect(x: 0, y: 0, width: 100, height: 100)

    var parentView: UIView?
    var title: String?
    var subtitle: String?
    var titleLabel: UILabel?
    var subtitleLabel: UILabel?

    // MARK: - Initializers

    init(parentView: UIView) {
        super.init(frame: CustomNotificationView.placeholderFrame)

        self.parentView = parentView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UIView Callbacks

    override func didMoveToSuperview() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0))

        constraints.append(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1, constant: 0))

        // Dynamically size with content
        constraints.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))

        constraints.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))

        if let titleLabel = titleLabel {
            constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))

            constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        }

        NSLayoutConstraint.activate(constraints)
    }


    // MARK: - View Setup

    func setupViews() {
        setupLabels()

        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupLabels() {
        guard let title = title else {
            return
        }

        titleLabel = UILabel(frame: CustomNotificationView.placeholderFrame)
        titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        titleLabel!.numberOfLines = 0

        titleLabel!.text = title

        addSubview(titleLabel!)
    }

    // MARK: - Displaying and Hiding

    func displayNotification(title: String, onComplete: @escaping () -> Void) {
        guard let parentView = parentView else {
            print("Parent view is required.  Notification: \(title) will not be displayed")
            return
        }

        self.title = title
        self.backgroundColor = UIColor.lightGray

        setupViews()

        parentView.addSubview(self)

        UIView.animate(withDuration: 1.5, animations: { self.alpha = 0 }) {(Bool)
            in
            onComplete()
        }
    }

}
