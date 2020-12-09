//
//  PropertyOwner.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-04.
//



//in USE!!!!!
import Foundation
import Firebase

struct PropertyOwner: Identifiable {
    var id = ""
    var ownerId = ""
    var name = ""
    
    func savePropertyOwner() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let currentUser = Auth.auth().currentUser
            
        let userData = ["ownerId" : currentUser?.uid, "name" : name ]
        
        ref.child("PropertyOwners").child("owners").child(currentUser!.uid).setValue(userData) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
              print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully! \(String(describing: ref.key))")
            }
          }
    }
    
}








