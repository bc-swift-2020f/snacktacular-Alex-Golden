//
//  Spot.swift
//  Snacktacular
//
//  Created by Alex Golden on 11/1/20.
//

import Foundation
import Firebase
import MapKit
 

class Spot: NSObject, MKAnnotation {
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var averageRating: Double
    var numberOfReviews: Int
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["name": name, "address": address, "latitude": latitude, "longitude": longitude, "averageRating": averageRating, "numberOfReviews": numberOfReviews, "postingUserID": postingUserID, "documentID": documentID]
    }
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return name
    }
    var subtitle: String?{
        return address
    }
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, averageRating: Double, numberOfReviews: Int, postingUserID: String, documentID: String) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.averageRating = averageRating
        self.numberOfReviews = numberOfReviews
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience override init() {
        self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! Double? ?? 0.0
        let longitude = dictionary["longitude"] as! Double? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let averageRating = dictionary["averageRating"] as! Double? ?? 0.0
        let numberOfReviews = dictionary["numberOfReviews"] as! Int? ?? 0
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(name: name, address: address, coordinate: coordinate, averageRating: averageRating, numberOfReviews: numberOfReviews, postingUserID: "", documentID: "")
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
    func updateAverageRating(completed: @escaping() -> ()) {
        let db = Firestore.firestore()
        let reviewsRef = db.collection("spots").document(documentID).collection("reviews")
        //get all reviews
        reviewsRef.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("error: failed to get query snapshot of reviews from reviews ref")
                return completed()
            }
            var ratingTotal = 0.0
            for document in querySnapshot!.documents {
                let reviewDictionary = document.data()
                let rating = reviewDictionary["rating"] as! Int ?? 0
                ratingTotal = ratingTotal + Double(rating)
            }
            self.averageRating = ratingTotal / Double(querySnapshot!.count)
            self.numberOfReviews = querySnapshot!.count
            let dataToSave = self.dictionary
            let spotRef = db.collection("spots").document(self.documentID)
            spotRef.setData(dataToSave) { (error) in
                if let error = error {
                    print("error updating document in spot after changing info \(error.localizedDescription)")
                    completed()
                } else {
                    print("new average updated")
                    completed()
                }
            }
        }
    }
    
}
