//
//  PlaceHolderTextView.swift
//  portfolioTabBar
//
//  Created by 임국성 on 25/07/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import UIKit

class PlaceHolderTextView: UITextView {
    func setBorder(width:CGFloat, color:UIColor, corner: CGFloat) -> Void {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = corner
    }
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8)
    }
    
    func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
    }
    
    @objc private func handleTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
}
