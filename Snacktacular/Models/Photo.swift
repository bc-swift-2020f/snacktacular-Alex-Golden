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
    
    func saveData(spot: Spot, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        //convert photo.image to data type to be stored in firebase storage
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("Error: could not convert photo.image to data")
            return
        }
        //create metadata to see images in firebase console storage
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        //create file name if neccessary
        if documentID == "" {
            documentID = UUID().uuidString
        }
        
        //create a storage reference to upload his image file to spots folder
        let storageRef = storage.reference().child(spot.documentID).child(documentID)
        
        //create an upload task
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetaData) {
            (metadata, error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        uploadTask.observe(.success){ (snapshot) in
            print("Upload to firebase storage was successful")
            storageRef.downloadURL { (url, error) in
                guard error == nil else {
                    print("error: could not create a download url")
                    return
                    completion(false)
                }
                guard let url = url else {
                    print("error: url was nil")
                    return
                    completion(false)
                }
                self.photoURL = "\(url)"
                
                //create a dictionary representing the data we want to save
                let dataToSave: [String: Any] = self.dictionary
                let ref = db.collection("spots").document(spot.documentID).collection("photos").document(self.documentID)
                   ref.setData(dataToSave) { (error) in
                       guard error == nil else {
                           print("ERROR: updating document \(error!.localizedDescription) in spot: \(spot.documentID)")
                           return completion(false)
                       }
                       print("Updated document: \(self.documentID)")
                       completion(true)
                   }
            }
            
            //create a dictionary representing the data we want to save
            let dataToSave: [String: Any] = self.dictionary
            let ref = db.collection("spots").document(spot.documentID).collection("photos").document(self.documentID)
               ref.setData(dataToSave) { (error) in
                   guard error == nil else {
                       print("ERROR: updating document \(error!.localizedDescription) in spot: \(spot.documentID)")
                       return completion(false)
                   }
                   print("Updated document: \(self.documentID)")
                   completion(true)
               }
            
        }
        uploadTask.observe(.failure){ (snapshot) in
            if let error = snapshot.error {
                print("error: upload task for file \(self.documentID) failed, with \(error.localizedDescription)")
        }
            completion(false)
        }
    }
    func loadImage(spot: Spot, completion: @escaping (Bool) -> ()) {
        guard spot.documentID != "" else {
            print("error did not pass a valid spot into loadImage")
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child(spot.documentID).child(documentID)
        storageRef.getData(maxSize: 25 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("an error occured while reading in data \(error.localizedDescription)")
                return completion(false)
            } else {
                self.image = UIImage(data: data!) ?? UIImage()
                return completion(true)
            }
        }
    }
    func deleteData(spot: Spot, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("spots").document(spot.documentID).collection("photos").document(documentID).delete { (error) in
            if let error = error {
                print("Error: error deleting photo \(self.documentID)")
                completion(false)
            } else {
                self.deleteImage(spot: Spot)
                    completion(true)
                
            }
        }
    }
    private func deleteImage(spot: Spot) {
        guard spot.documentID != "" else {
            print("error did not pass a valid spot into delete image")
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child(spot.documentID).child(documentID)
        storageRef.delete {error in
            if let error = error {
                print(" error \(error.localizedDescription)")
            }
            print("photo deleted")
        }
    }
}
