//
//  Photo.swift
//  Snacktacular
//
//  Created by Alex Golden on 11/15/20.
//

import UIKit
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var photoUserID: String
    var photoUserEmail: String
    var date: Date
    var photoURL: String
    var documentID: String
    
    var dictionary: [String: Any] {
        let timeIntervalDate = date.timeIntervalSince1970
        return ["description": description, "photoUserID": photoUserID, "photoUserEmail": photoUserEmail, "date": timeIntervalDate, "photoURL": photoURL]
    }
    init(image: UIImage, description: String, photoUserID: String, photoUserEmail: String, date: Date, photoURL: String, documentID: String) {
        self.image = image
        self.description = description
        self.photoUserID = photoUserID
        self.photoUserEmail = photoUserEmail
        self.photoURL = photoURL
        self.date = date
        self.documentID = documentID
    }
    convenience init() {
        let photoUserID = Auth.auth().currentUser?.uid ?? ""
        let photoUserEmail = Auth.auth().currentUser?.email ?? "Unknown Email"
        self.init(image: UIImage(), description: "", photoUserID: photoUserID, photoUserEmail: photoUserEmail, date: Date(), photoURL: "", documentID: "")
    }
    convenience init(dictionary: [String: Any]) {
        let description = dictionary["description"] as! String? ?? ""
        let photoUserID = dictionary["photoUserID"] as! String? ?? ""
        let photoUserEmail = dictionary["photoUserEmail"] as! String? ?? ""
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        let photoURL = dictionary["photoURL"] as! String? ?? ""

        self.init(image: UIImage(), description: description, photoUserID: photoUserID, photoUserEmail: photoUserEmail, date: date, photoURL: photoURL, documentID: "")
    }
}
