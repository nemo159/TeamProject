//
//  ProfileViewTableCell.swift
//  portfolioTabBar
//
//  Created by 임국성 on 09/08/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import UIKit

class ProfileViewTableCell: UITableViewCell {
    @IBOutlet var profileViewCollection: ProfileViewCollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
