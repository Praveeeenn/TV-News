//
//  NewsCell.swift
//  TV News
//
//  Created by Praveen on 21/03/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit

class NewsCell: UICollectionViewCell {
    @IBOutlet weak var imageView: RemoteImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet var unFocusedConstraint: NSLayoutConstraint!
    var focusConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        focusConstraint = textLabel.topAnchor.constraint(equalTo: imageView.focusedFrameGuide.bottomAnchor, constant: 15)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        focusConstraint?.isActive = isFocused
        unFocusedConstraint.isActive = !isFocused
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        setNeedsUpdateConstraints()
        
        coordinator.addCoordinatedAnimations({
            self.layoutIfNeeded()
        })
    }
    
}
