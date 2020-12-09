//
//  PropertyModel.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-06.
//

import Foundation
import SwiftUI
import Firebase

struct PropertyModel: Identifiable {
    var id : String
    var propertyName: String
    
//    func saveProperty() {
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
//        let userData = ["owner": Auth.auth().currentUser!.uid, "propertyName" : propertyName]
//        ref.child("PropertyOwners").child("properties").child(Auth.auth().currentUser!.uid).childByAutoId().setValue(userData) { err, result in
//            print("property id child by AuTo id", result.key!)
//        }
//    }

    
}
