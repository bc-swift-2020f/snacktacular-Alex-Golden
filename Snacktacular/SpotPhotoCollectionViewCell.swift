//
//  SpotPhotoCollectionViewCell.swift
//  Snacktacular
//
//  Created by Alex Golden on 11/16/20.
//

import UIKit

class SpotPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    var spot: Spot!
    var photo: Photo! {
        didSet {
            photo.loadImage(spot: spot) { (success) in
                if success {
                    self.photoImageView.image = self.photo.image
                } else {
                print("error no success in loading photo")
                }
            }
        }
    }
    
}
