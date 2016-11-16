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
    var caption: String?
    var titleLabel: UILabel?
    var captionLabel: UILabel?
    var constraintList = [NSLayoutConstraint]()

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
        // self constraints
        constraintList.append(
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0))

        constraintList.append(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1, constant: 0))

        constraintList.append(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .lessThanOrEqual, toItem: parentView, attribute: .height, multiplier: 0.5, constant: 0))

        constraintList.append(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .lessThanOrEqual, toItem: parentView, attribute: .width, multiplier: 0.5, constant: 0))

        // title label constraints
        if let titleLabel = titleLabel {
            constraintList.append(NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 0))

            constraintList.append(NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 0))

            constraintList.append(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1, constant: 0))

            if let captionLabel = captionLabel {
                constraintList.append(NSLayoutConstraint(item: captionLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 0))

                constraintList.append(NSLayoutConstraint(item: captionLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 0))

                constraintList.append(NSLayoutConstraint(item: captionLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 10))

                constraintList.append(NSLayoutConstraint(item: captionLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1, constant: 0))
            }
            else {
                constraintList.append(NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1, constant: 0))
            }
        }

        NSLayoutConstraint.activate(constraintList)
    }

    // MARK: - View Setup

    func setupViews() {
        setupLabels()

        self.backgroundColor = UIColor.lightGray
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupLabels() {
        setupTitleLabel()
        setupCaptionLabel()
    }

    func setupTitleLabel() {
        guard let title = title else { return }

        titleLabel = UILabel(frame: CustomNotificationView.placeholderFrame)

        guard let titleLabel = titleLabel else { return }

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        titleLabel.text = title

        addSubview(titleLabel)
    }

    func setupCaptionLabel() {
        guard let caption = caption else {
            return
        }

        captionLabel = UILabel(frame: CustomNotificationView.placeholderFrame)

        guard let captionLabel = captionLabel else { return }

        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.numberOfLines = 0

        captionLabel.text = caption
        captionLabel.textAlignment = .center

        addSubview(captionLabel)
    }

    // MARK: - Displaying and Hiding

    func displayNotification(shouldFade: Bool, onComplete: (() -> ())?) {
        guard let parentView = parentView else {
            print("Parent view is required.  Notification: \(title) will not be displayed")
            return
        }

        if superview == nil {
            setupViews()
            parentView.addSubview(self)
        }

        parentView.bringSubview(toFront: self)
        self.alpha = 100

        if shouldFade  {
            UIView.animate(withDuration: 1, animations: { self.alpha = 0 }) {
                (Bool)
                in
                onComplete?()
            }
        }
    }

    func hideNotification() {
        alpha = 0
    }
}
