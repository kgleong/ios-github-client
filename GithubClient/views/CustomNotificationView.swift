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
    var spinner: UIView?
    var showSpinner = false

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

        constraintList.append(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .lessThanOrEqual, toItem: superview, attribute: .height, multiplier: 0.5, constant: 0))

        constraintList.append(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .lessThanOrEqual, toItem: superview, attribute: .width, multiplier: 0.5, constant: 0))


        if let spinner = spinner {
            constraintList.append(NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))

            constraintList.append(NSLayoutConstraint(item: spinner, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))

            constraintList.append(NSLayoutConstraint(item: spinner, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))

            constraintList.append(NSLayoutConstraint(item: spinner, attribute: .top, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1, constant: 0))
        }

        // title label constraints
        if let titleLabel = titleLabel {

            // Adjsut position if spinner is displayed
            if let spinner = spinner {
                constraintList.append(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: spinner, attribute: .bottom, multiplier: 1, constant: 5))
            }
            else {
                constraintList.append(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1, constant: 0))
            }

            constraintList.append(NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 0))

            constraintList.append(NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 0))


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

        if showSpinner {
            setupSpinner()
        }

        self.backgroundColor = UIColor.lightGray
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupLabels() {
        setupTitleLabel()
        setupCaptionLabel()
    }

    func setupSpinner() {
        spinner = UIView()
        spinner?.translatesAutoresizingMaskIntoConstraints = false

        guard let spinner = spinner else { return }

        spinner.backgroundColor = UIColor.red
        spinner.layer.borderColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.95).cgColor
        spinner.layer.borderWidth = 2
        spinner.layer.cornerRadius = 5
        spinner.layer.masksToBounds = true

        addSubview(spinner)
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

        if let spinner = spinner {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = CGFloat(M_PI * 2)
            rotationAnimation.beginTime = 0.0
            rotationAnimation.duration = 2.0

            let basicColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
            basicColorAnimation.fromValue = UIColor.red
            basicColorAnimation.toValue = UIColor.blue
            basicColorAnimation.beginTime = 0.0
            basicColorAnimation.duration = 2.0


            let animationGroup = CAAnimationGroup()
            animationGroup.animations = [rotationAnimation, basicColorAnimation]
            animationGroup.repeatCount = Float.infinity
            animationGroup.duration = 2.0

            //spinner.layer.add(animationGroup, forKey: nil)

            UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.repeat, .autoreverse, .calculationModePaced], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0) {
                    spinner.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 2)/3)
                    spinner.backgroundColor = UIColor.blue
                }
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0) {
                    spinner.transform = CGAffineTransform(rotationAngle: 2*CGFloat(M_PI * 2)/3)
                    spinner.backgroundColor = UIColor.green
                }
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0) {
                    spinner.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 2))
                    spinner.backgroundColor = UIColor.red
                }
            }, completion: nil)
        }

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
