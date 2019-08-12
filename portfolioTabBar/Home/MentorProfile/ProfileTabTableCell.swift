//
//  ProfileTabCell.swift
//  portfolioTabBar
//
//  Created by 임국성 on 09/08/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import UIKit

class ProfileTabTableCell: UITableViewCell {
    @IBOutlet var profileTabCollection: ProfileTabCollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileTabCollection.profileTabSetCollectionItems()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
