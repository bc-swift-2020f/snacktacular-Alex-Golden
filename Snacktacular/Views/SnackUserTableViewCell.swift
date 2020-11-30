//
//  SnackUserTableViewCell.swift
//  Snacktacular
//
//  Created by Alex Golden on 11/30/20.
//

import UIKit
import SDWebImage
class SnackUserTableViewCell: UITableViewCell {

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var userSinceLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var snackUser: SnackUser! {
        displayNameLabel.text = snackUser.displayName
        emailLabel.text = snackUser.email
        userSinceLabel.text = "\(dateFormatter.string(from: snackUser.userSince))"
        
        //round corners of imageview
        userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        
        
        guard let url = URL(string: snackUser.photoURL) else {
            userImageView.image = UIImage(systemName: "person.crop.circle")
            return
        }
        userImageView.sd_imageTransition = .fade
        userImageView.sd_imageTransition?.duration = 0.1
        userImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.crop.circle"))
    }
}
