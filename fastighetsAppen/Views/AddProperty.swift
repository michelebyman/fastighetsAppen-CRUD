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
    @State var isError = false
    @State var isAddPropertyMode = false

    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea(.all)
            VStack{
                Text("Welcome!")
                    .foregroundColor(Color(.white))
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding(.top, -40)
                if (properties.count == 0) {
                    Text("Add Properties")
                        .foregroundColor(Color(.white))
                        .font(.body)
                        .padding(.bottom)
                }

                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(properties) { item in
                            NavigationLink(destination: AddTenants(id : item.id, propertyName: item.propertyName)) {
                                VStack {
                                    Image(systemName: "house.fill")
                                        .resizable()
                                        .foregroundColor(Color(.white))
                                        .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding(.top,5)
                                    Text(item.propertyName).font(.callout).padding(.top,5)
                                    if let counter = item.tentansCounter {
                                        if counter != "" {
                                            HStack {
                                                Image(systemName: "person.fill")
                                                    .resizable()
                                                    .frame(width: 12, height: 12)
                                                Text(item.tentansCounter!).font(.callout)
                                            }
                                            .foregroundColor(Color(.white))
                                            .padding(.top,5)
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                            .padding()
                            .border(Color.white, width: 2)
                        }.background(Color("cardColor"))
                    }
                }.frame(maxWidth: .infinity, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding()
                Spacer()
               
            }
            .navigationBarItems(
                trailing:
                    Button(action: {isAddPropertyMode.toggle()}) {
                        ZStack {
                            Image(systemName: "plus").font(.title3)
                        }.frame(width: 50, height: 50)
                    }
            )
            .padding(.bottom, 30)
            
            .onAppear() {
                getPropertyName()
                getProperties()

            }
            .sheet(isPresented: $isAddPropertyMode, content: {
                ZStack {
                    Color("backgroundColor").edgesIgnoringSafeArea(.all)
                    VStack {
                        HStack {
                            Button(action: {isAddPropertyMode.toggle()}) {
                                Text("Cancel")
                            }
                            Spacer()
                            Text("New Property").font(.body).fontWeight(.semibold)
                            Spacer()
                            Button(action: saveProperty) {
                                Text("Done")
                            }.disabled(propertyName.isEmpty)

                        }.padding()

                        Spacer()
                        InputfieldView(inputText: $propertyName, imageName: "house", placeholderText: "Add property name", keyboardType: .default)
                            .padding(.top, 30)
                            .padding(.horizontal)
                        Spacer()
                    }
                }


            })
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
        if propertyName == "" {isError = true; return}
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let propertyData = ["owner": Auth.auth().currentUser!.uid, "propertyName" : propertyName]
        ref.child("PropertyOwners").child("properties").child(Auth.auth().currentUser!.uid).childByAutoId().setValue(propertyData) { err, result in
            //                print("id I need!!!!" \(result.key!))
        }
        getProperties()
        propertyName = ""
        isAddPropertyMode = false
        isError = false
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
