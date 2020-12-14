//
//  AddTenants.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-07.
//

import SwiftUI
import Firebase
import MessageUI


struct AddTenants: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var name = ""
    @State var lastname = ""
    @State var email = ""
    @State var phone = ""
    @State var tenants = [TenantModel]()
    
    @State var id : String
    @State var propertyName : String
    
    @State private var showingAlert = false
    @State var isAddTenentMode = false
   

    
    let smssend = SMSSender()
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea(.all)
            ScrollView {
                VStack {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(tenants) { tenant in
                                NavigationLink(destination: TenantDetailView(tenant: TenantModel(id: tenant.id, name: tenant.name, lastname: tenant.lastname, email: tenant.email, phone: tenant.phone), propertyID: id)) {
                                    VStack {
                                        Image(systemName: "person.fill")
                                            .resizable().frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .foregroundColor(Color(.white))
                                        
                                        HStack {
                                            Text("\(tenant.name) \(tenant.lastname)")
                                                .font(.caption)
                                        }.padding(.top,5)
                                        Text(tenant.email)
                                            .font(.caption)
                                            .foregroundColor(Color(.white))
                                            .padding(.top,5)
                                        Text(tenant.phone)
                                            .font(.caption)
                                            .foregroundColor(Color(.white))
                                            .padding(.top,5)
                                            .padding(.bottom,5)
                                        
                                    }
                                }
                                .frame(maxWidth: .infinity, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .padding()
                                .border(Color.white, width: 2)
                            }
                        }
                    }
                    .padding()
                    if (tenants.count > 0) {
                        Button(action: sendMessage) {
                            Text((tenants.count > 1) ? "Send group SMS" : "Send SMS")
                                .foregroundColor(Color(.white))
                                .frame(maxWidth: .infinity, minHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        .background(Color(.systemPink))
                        .cornerRadius(25)
                        .padding(.top, 10)
                    }
                    
                    Text("Add tenants for \(propertyName) ")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding()

                    if (tenants.count == 0 || isAddTenentMode) {
                        InputfieldView(inputText: $name, imageName: "person", placeholderText: "Name", keyboardType: .default)
                        InputfieldView(inputText: $lastname, imageName: "person", placeholderText: "lastname", keyboardType: .default)
                        InputfieldView(inputText: $email, imageName: "envelope", placeholderText: "Email", keyboardType: .emailAddress)
                        InputfieldView(inputText: $phone, imageName: "phone", placeholderText: "Phone", keyboardType: .numberPad)

                        Button(action: addTenants) {
                            Text("Add tenant")
                                .foregroundColor(Color(.white))
                                .frame(maxWidth: .infinity, minHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        .background(Color(.systemPink))
                        .cornerRadius(25)
                        .padding(.top, 10)
                    } else {
                        Button(action: {isAddTenentMode.toggle()}) {
                            Text("Add")
                                .foregroundColor(Color(.white))
                                .frame(maxWidth: .infinity, minHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        .background(Color(.systemPink))
                        .cornerRadius(25)
                        .padding(.top, 10)
                    }
                    
                    
                    

                    
                }.padding()
                .navigationBarItems(
                    trailing:
                        Button(action: {
                            self.showingAlert = true
                        }) {
                            Text("Delete property")
                        }
                        .alert(isPresented:$showingAlert) {
                            Alert(title: Text("Are you sure you want to delete this property and all tenants?"), message: Text("There is no undo"), primaryButton: .destructive(Text("Delete")) {
                                deleteProperty()
                            }, secondaryButton: .cancel())
                        }
                )
                .padding(.bottom, 30)
            }

            .onAppear() {
                getTenants()
            }
        }
    }
    
    
    func sendMessage() {
        
        var smsnumbers = [String]()
        tenants.forEach { tenant in
            smsnumbers.append(tenant.phone)
        }
        
        smssend.sendSMS(sendTo: smsnumbers)
    }
    
    func deleteProperty() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("PropertyOwners").child("properties").child(Auth.auth().currentUser!.uid).child(id).removeValue()
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func addTenants() {
        print("PHONE IS \(phone)")
        if name == "" || lastname == "" || email == "" || phone == "" {return}
        let newTenant = TenantModel(id: id, name: name, lastname: lastname, email: email, phone: phone)
        newTenant.addTenant(tenant: newTenant, propertyID: id)
        name = ""
        phone = ""
        lastname = ""
        email = ""
        getTenants()
        
    }
    
    func getTenants() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("PropertyOwners").child("properties").child(Auth.auth().currentUser!.uid).child(id).child("tenants").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get tenants
            var temporaryTenants = [TenantModel]()
            for child in snapshot.children
            {
                let childSnap = child as! DataSnapshot
                let value = childSnap.value as? NSDictionary
                let tenantName = value?["name"] as? String ?? ""
                let tenantlastname = value?["lastname"] as? String ?? ""
                let tenantEmail = value?["email"] as? String ?? ""
                let tenantPhone = value?["phone"] as? String ?? ""
                //                child by auto id  below
                let id = childSnap.key

                temporaryTenants.append(TenantModel(id: id, name: tenantName, lastname: tenantlastname, email: tenantEmail, phone: tenantPhone))
            }
            tenants = temporaryTenants
            tenants.reverse()
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}





struct AddTenants_Previews: PreviewProvider {
    static var previews: some View {
        let id = "ID"
        let propertyName = "Huset"
        AddTenants(id: id, propertyName: propertyName)
    }
}




