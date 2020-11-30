//
//  SnackUsers.swift
//  Snacktacular
//
//  Created by Alex Golden on 11/30/20.
//

import Foundation
import Firebase

class SnackUsers {
    var userArray: [SnackUser] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.userArray = []
            for document in querySnapshot!.documents {
                let spot = SnackUser(dictionary: document.data())
                spot.documentID = document.documentID
                self.userArray.append(spot)
            }
            completed()
        }
    }
}
