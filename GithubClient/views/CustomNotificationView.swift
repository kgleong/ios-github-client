//
//  CustomNotificationView.swift
//  GithubClient
//
//  Created by Kevin Leong on 11/10/16.
//  Copyright © 2016 Orangemako. All rights reserved.
//

import UIKit

class CustomNotificationView: UIView {
    static var defaultFrame = CGRect(x: 0, y: 300, width: 200, height: 200)

    var parentView: UIView?
    var title: String?

    init(frame: CGRect?, view: UIView) {
        if frame == nil {
            super.init(frame: CustomNotificationView.defaultFrame)
        }
        else {
            super.init(frame: frame!)
        }


        self.parentView = view
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - View Setup
    func setupViews() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.text = title!
        label.backgroundColor = UIColor.lightGray

        self.addSubview(label)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }

    // MARK: - Displaying and Hiding

    func displayNotification(title: String, onComplete: @escaping () -> Void) {
        guard let parentView = parentView else {
            return
        }
        
        self.title = title
        self.backgroundColor = UIColor.red

        setupViews()

        parentView.addSubview(self)

        UIView.animate(withDuration: 1.5, animations: { self.alpha = 0 }) {(Bool)
            in
            self.removeFromSuperview()
            onComplete()
        }
    }

}
