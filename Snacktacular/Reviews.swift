//
//  Reviews.swift
//  Snacktacular
//
//  Created by Alex Golden on 11/9/20.
//

import Foundation
import Firebase


class Reviews {
    var reviewArray: [Review] = []
    var db: Firestore!
    init() {
        db = Firestore.firestore()
    }
}

