//
//  HomeMentorCollection.swift
//  portfolioTabBar
//
//  Created by 임국성 on 09/08/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import UIKit
import Firebase

let mentorReuseIdentifier = "MentorCell"

class HomeMentorCollection: UICollectionView , UICollectionViewDelegate, UICollectionViewDataSource{
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as UITableViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mentorReuseIdentifier, for: indexPath) as UICollectionViewCell
//        cell.licenseImageView.image = licenseImageArray[indexPath.row]
        cell.layer.cornerRadius = 3
        cell.clipsToBounds = true
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
}

extension HomeMentorCollection: UICollectionViewDelegateFlowLayout {
    //Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewCellWidth = collectionView.frame.width
        
        return CGSize(width: collectionViewCellWidth, height: collectionViewCellWidth)
    }
    
    //Top & Bottom Margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    //Side Margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
}
