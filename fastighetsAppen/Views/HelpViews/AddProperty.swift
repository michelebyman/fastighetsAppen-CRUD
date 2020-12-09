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
                Text("Hello! \(username)").foregroundColor(Color(.white))
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(properties) { item in
                            NavigationLink(destination: AddTenants(id : item.id)) {
                                VStack {
                                    Image(systemName: "house.fill").resizable().frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
                                    Text(item.propertyName).font(.caption2).padding(.top,5)
                                    Text(item.id).font(.caption2).padding(.top,5)
                                }
                               
                            }.frame(maxWidth: .infinity, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding().border(Color.white, width: 2)
                        }
                    }
                }.padding()
                TextField("Name", text: $propertyName)
                    .font(.body)
                    .padding()
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
                getProperties()
                var ref: DatabaseReference!
                
                ref = Database.database().reference()
                let userID = Auth.auth().currentUser?.uid
                
                let reference = Database.database().reference().child(userID!).queryOrdered(byChild: "propertyName")
                reference.queryEqual(toValue: userID!).observeSingleEvent(of: .childAdded) { (snapshot) in
                     let dictionary = snapshot.value as! [String : Any]
                     let firstName = dictionary["firstName"]
                    print(firstName!)
                }
                
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
        }
        
    }
    
    
    func saveProperty() {
        if propertyName == "" {return}
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        id = UUID().uuidString
        let userData = ["id": id, "owner": Auth.auth().currentUser!.uid, "propertyName" : propertyName]
        
        
        ref.child("PropertyOwners").child("properties/property").child(Auth.auth().currentUser!.uid).childByAutoId().setValue(userData) { err, result in
            
//            DispatchQueue.main.async {
//                id = result.key!
//                print("id I need!!!!",id)
//            }
           
            
        }
        
        
        
        
        getProperties()
        propertyName = ""
    }
    
    
    
//    func addProperty() {
//        if propertyName == "" {return}
//        let saveProperty = PropertyModel(propertyName: propertyName )
////        saveProperty.saveProperty()
//        getProperties()
//        propertyName = ""
//    }
    
    func getProperties() {
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        
        ref.child("PropertyOwners").child("properties/property").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get properties
            
            var tempProperties = [PropertyModel]()
            for child in snapshot.children
            {
                let childSnap = child as! DataSnapshot
                let value = childSnap.value as? NSDictionary
                let propertyName = value?["propertyName"] as? String ?? ""
                let id = value?["id"] as? String ?? ""
                print("property name ----->",propertyName)
              
                tempProperties.append(PropertyModel(id: id, propertyName: propertyName))
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
