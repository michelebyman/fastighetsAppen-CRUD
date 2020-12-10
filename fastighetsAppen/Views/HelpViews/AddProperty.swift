//
//  AddPropertyAndTenantsView.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-06.
//

import SwiftUI
import Firebase

struct AddProperty: View {
    
    @State var username = ""
    @State var propertyName = ""
    @State var properties = [PropertyModel]()
    @State var id = ""
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea(.all)
            VStack{
                Text("Hello \(username)").foregroundColor(Color(.white))
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(properties) { item in
                            NavigationLink(destination: AddTenants(id : item.id, propertyName: item.propertyName)) {
                                VStack {
                                    Image(systemName: "house.fill").resizable().frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    Text(item.propertyName).font(.caption).padding(.top,5)
                                    if let counter = item.tentansCounter {
                                        if counter != "" {
                                        HStack {
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .frame(width: 10, height: 10)
                                            Text(item.tentansCounter!).font(.caption2)
                                        }.padding(.top,5)
                                        }
                                    }

                                }
                               
                            }
                            .frame(maxWidth: .infinity, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding()
                            .border(Color.white, width: 2)
                        }
                    }
                }
                .padding()
                Spacer()
                ZStack(alignment: .leading) {
                    if propertyName.isEmpty {
                        HStack {
                            Image(systemName: "house").foregroundColor(.white)
                            Text("Add property name")
                            .foregroundColor(.white )
                            .font(.body)
                            
                        }.padding(.leading)
                    }
                    TextField( "" ,text: $propertyName)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .overlay(RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white,  lineWidth: 2)
                        )
                }.padding()
                
                Button(action: saveProperty) {
                    Text("Add Property")
                        .foregroundColor(Color(.white))
                        .frame(maxWidth: .infinity, minHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                .background(Color(.systemPink))
                .cornerRadius(25)
                .padding()
            }
            .onAppear() {
                getPropertyName()
                getProperties()
               
            }
        }
        
    }
    
    
    func getPropertyName() {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("PropertyOwners").child("owners").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let usernameFromDatabase = value?["name"] as? String ?? ""
//                    print("username------->",username)
            username = usernameFromDatabase
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func saveProperty() {
        if propertyName == "" {return}
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let propertyData = ["owner": Auth.auth().currentUser!.uid, "propertyName" : propertyName]
        
        ref.child("PropertyOwners").child("properties").child(Auth.auth().currentUser!.uid).childByAutoId().setValue(propertyData) { err, result in
//                print("id I need!!!!" \(result.key!))
        }
        getProperties()
        propertyName = ""
    }
    
    func getProperties() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("PropertyOwners").child("properties").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get properties
            var tempProperties = [PropertyModel]()
            for child in snapshot.children
            {
                let childSnap = child as! DataSnapshot
                let value = childSnap.value as? NSDictionary
                let propertyName = value?["propertyName"] as? String ?? ""
//                child by auto id  below
                let id = childSnap.key
                var tentansCounter = ""
                if let tenants = value?["tenants"] as? [String : AnyObject] {
                    print(type(of: tenants))
                    print("tenants object",tenants.count)
                    tentansCounter = String(tenants.count)
                    
                }
                print("property name ----->",propertyName)
              
                tempProperties.append(PropertyModel(id: id, propertyName: propertyName, tentansCounter: tentansCounter ))
            }
            properties = tempProperties
            // ...
            properties.reverse()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

struct AddProperty_Previews: PreviewProvider {
    static var previews: some View {
        AddProperty()
    }
}
