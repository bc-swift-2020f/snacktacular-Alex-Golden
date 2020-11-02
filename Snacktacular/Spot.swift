//
//  Spot.swift
//  Snacktacular
//
//  Created by Alex Golden on 11/1/20.
//

import Foundation
 

class Spot {
    var name: String
    var address: String
    var averageRating: Double
    var numberOfReviews: Int
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["name": name, "address": address, "averageRating": averageRating, "numberOfReviews": numberOfReviews, "postingUserID": postingUserID, "documentID": documentID]
    }
    
    init(name: String, address: String, averageRating: Double, numberOfReviews: Int, postingUserID: String, documentID: String) {
        self.name = name
        self.address = address
        self.averageRating = averageRating
        self.numberOfReviews = numberOfReviews
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(name: "", address: "", averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: "")
    }
    
func saveData(completion: @escaping (Bool) -> ()) {
       let db = Firestore.firestore()
       // Grab the user ID
       guard let postingUserID = Auth.auth().currentUser?.uid else {
           print("ERROR: Could not save data because we don't have a valid postingUserID.")
           return completion(false)
       }
       self.postingUserID = postingUserID
       // create the dictionary representing data we want to save
       let dataToSave: [String : Any] = self.dictionary
       // if we HAVE saved a record, we'll have an ID, otherwise .addDocument will create one.
       if self.documentID == "" { // create a new document via .addDocument
           var ref: DocumentReference? = nil // Firestore will create a new ID for us
           ref = db.collection("spots").addDocument(data: dataToSave) { (error) in
               guard error == nil else {
                   print("ERROR: adding document \(error!.localizedDescription)")
                   return completion(false)
               }
               self.documentID = ref!.documentID
               print("Added document: \(self.documentID)")
               completion(true)
           }
       } else { // else save to the existing documentID
           let ref = db.collection("spots").document(self.documentID)
           ref.setData(dataToSave) { (error) in
               guard error == nil else {
                   print("ERROR: updating document \(error!.localizedDescription)")
                   return completion(false)
               }
               print("Updated document: \(self.documentID)")
               completion(true)
           }
       }
}
}