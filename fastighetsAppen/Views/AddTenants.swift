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
                    Text("Add Tenants For")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(.white))
                        .padding(.top, -40)
                    Text("\(propertyName)")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(.white))
                        .padding(.bottom)
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
                                                .font(.callout)
                                        }.padding(.top,5)
                                        Text(tenant.email)
                                            .font(.callout)
                                            .foregroundColor(Color(.white))
                                            .padding(.top,5)
                                        Text(tenant.phone)
                                            .font(.callout)
                                            .foregroundColor(Color(.white))
                                            .padding(.top,5)
                                            .padding(.bottom,5)
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .padding()
                                .border(Color.white, width: 2)


                            }.background(Color("cardColor"))
                        }
                    }
                    .padding()
                    if (tenants.count > 0) {
                        ButtonView(text:  (tenants.count > 1) ? "Send group SMS" : "Send SMS", imageName: "message", backgroundColor:  Color("secondaryButton"), action: {sendMessage()}, foregroundColor: Color("secondaryButtonText"))

                    }
                    ButtonView(text: "Delete property", imageName:"minus.circle", backgroundColor: Color(.red), action: {self.showingAlert = true}) .alert(isPresented:$showingAlert) {
                        Alert(title: Text("Are you sure you want to delete this property and all tenants?"), message: Text("There is no undo"), primaryButton: .destructive(Text("Delete")) {
                            deleteProperty()
                        }, secondaryButton: .cancel())
                    }

                }.padding()
                .navigationBarItems(
                    trailing:
                        Button(action: {isAddTenentMode.toggle()}) {
                            ZStack {
                                Image(systemName: "plus").font(.title3)
                            }.frame(width: 50, height: 50)
                        }
                )

            }

            .onAppear() {
                getTenants()
            }
            .sheet(isPresented: $isAddTenentMode, content: {
                ZStack {
                    Color("backgroundColor")
                    VStack {
                        HStack {
                            Button(action: {isAddTenentMode.toggle()}) {
                                Text("Cancel")
                            }
                            Spacer()
                            Text("New Tenant").font(.body).fontWeight(.semibold)
                            Spacer()
                            Button(action: addTenants) {
                                Text("Done")
                            }.disabled(name.isEmpty || lastname.isEmpty || phone.isEmpty)

                        }.padding()

                        Spacer()
                        InputfieldView(inputText: $name, imageName: "person", placeholderText: "Name", keyboardType: .default)
                        InputfieldView(inputText: $lastname, imageName: "person", placeholderText: "lastname", keyboardType: .default)
                        InputfieldView(inputText: $email, imageName: "envelope", placeholderText: "Email", keyboardType: .emailAddress)
                        InputfieldView(inputText: $phone, imageName: "phone", placeholderText: "Phone", keyboardType: .numberPad)
                        Spacer()
                    }
                }


            })
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
        isAddTenentMode = false
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




