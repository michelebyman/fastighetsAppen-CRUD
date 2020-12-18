//
//  TenantModel.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-06.
//

import Foundation
import SwiftUI
import Firebase

struct TenantModel: Identifiable {
    var id: String
    var name :  String
    var lastname : String
    var email : String
    var phone : String
    
    
    
    func addTenant(tenant : TenantModel, propertyID: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        var tenantData = ["name" : tenant.name]
        tenantData["lastname"] = tenant.lastname
        tenantData["email"] = tenant.email.lowercased()
        tenantData["phone"] = tenant.phone
        tenantData["id"] = tenant.id
        
        
//        ref.child("PropertyOwners").child("properties/property/tenants").child(id).childByAutoId().setValue(tenantData)
        ref.child("PropertyOwners").child("properties").child(Auth.auth().currentUser!.uid).child(propertyID).child("tenants").childByAutoId().setValue(tenantData)
    }
    
    
}
