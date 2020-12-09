//
//  AddTenants.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-07.
//

import SwiftUI
import Firebase

struct AddTenants: View {
    @State var name = ""
    @State var lastName = ""
    @State var email = ""
    
    @State var id : String
    
    var body: some View {
        VStack {
            
            Text("id from PropertyView \(id)")
            Text("ADD TENANTS").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            TextField("Tenant name", text: $name)
            TextField("Tenant lastName", text: $lastName)
            TextField("Tenant email", text: $email)
            Button(action: addTenants) {
                Text("Add tenant")
            }
        }.padding()
    }
    func addTenants() {
        if name == "" || lastName == "" || email == "" {return}
        print(name)
        print(lastName)
        print(email)
        
    
        let newTenant = TenantModel(id: id, name: name, lastName: lastName, email: email)
        newTenant.addTenant(tenant: newTenant, propertyID: id)
    
    }
}




struct AddTenants_Previews: PreviewProvider {
    static var previews: some View {
        let id = "hej"
        AddTenants(id: id)
    }
}
