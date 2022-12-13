//
//  AdsCollectionViewCell.swift
//  menodagq8gold
//
//  Created by Hussein Jouhar on 26.10.22.
//  Copyright © 2022 arabdevs. All rights reserved.
//

import UIKit
import Imaginary

class AdsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var adImg: UIImageView!
    
//    func setupCell(img: UIImage){
//        adImg.image = img
//        adImg.layer.cornerRadius = 5
//        adImg.clipsToBounds = true
//    }
    
    func setupCell(img: URL){
        
        adImg.setImage(url: img)
        adImg.layer.cornerRadius = 5
        adImg.clipsToBounds = true
    }
}
