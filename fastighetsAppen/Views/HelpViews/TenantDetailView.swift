//
//  TenantDetailView.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-14.
//

import SwiftUI
import Firebase

struct TenantDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var tenant: TenantModel
    @State var name = ""
    @State var lastname = ""
    @State var email = ""
    @State var phone = ""
    @State var propertyID : String

    @State var isEditMode = false

    @State var showingAlert = false

    let smssend = SMSSender()

    
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea(.all)
            ScrollView {
                VStack {
                    ZStack {
                        HStack {
                            Spacer()
                            if !isEditMode {
                                Button(action: {isEditMode = true}) {
                                    Text("Edit")
                                        .foregroundColor(Color(.systemPink))

                                }

                            }

                        }.offset(y: -50)
                        VStack {
                            Image(systemName: "person.fill").resizable().frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            HStack {
                                Text("\(name) \(lastname)")
                                    .font(.callout)
                            }.padding(.top,5)
                            Text(email)
                                .font(.callout)
                                .foregroundColor(Color(.white))
                                .padding(.top,5)
                            Text(phone)
                                .font(.callout)
                                .foregroundColor(Color(.white))
                                .padding(.top,5)
                                .padding(.bottom,5)
                        }



                    }
                    .frame(maxWidth: .infinity, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
                    .border(Color.white, width: 2)
                    if !isEditMode  {
                        Button(action: sendMessage) {
                            Text("Send SMS")
                                .foregroundColor(Color(.white))
                                .frame(maxWidth: .infinity, minHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        .background(Color(.systemPink))
                        .cornerRadius(25)
                        .padding(.top, 30)
                    }

                    if isEditMode {
                        InputfieldView(inputText: $name, imageName: "person", placeholderText: "Name", keyboardType: .default).padding(.top, 30)
                        InputfieldView(inputText: $lastname, imageName: "person", placeholderText: "lastname", keyboardType: .default)
                        InputfieldView(inputText: $email, imageName: "envelope", placeholderText: "Email", keyboardType: .emailAddress)
                        InputfieldView(inputText: $phone, imageName: "phone", placeholderText: "Phone", keyboardType: .numberPad)
                    }
                }
                .padding()

                .navigationBarItems(
                    trailing:

                        ZStack {
                            if isEditMode {
                                Button(action: updateTenant) {
                                    Text("Done")
                                }
                            } else {
                                Button(action: {
                                    self.showingAlert = true
                                }) {
                                    Text("Delete tenant")
                                }
                                .alert(isPresented:$showingAlert) {
                                    Alert(title: Text("Are you sure you want to delete this tenant"), message: Text("There is no undo"), primaryButton: .destructive(Text("Delete")) {
                                        deleteTenant()
                                    }, secondaryButton: .cancel())
                                }
                            }

                        }

                )
            }.onAppear {
                name = tenant.name
                lastname = tenant.lastname
                email = tenant.email
                phone = tenant.phone
            }
        }
    }


    func sendMessage() {
        var smsNumber = [String]()
        smsNumber.append(tenant.phone)
        smssend.sendSMS(sendTo: smsNumber)
    }


    func updateTenant() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("PropertyOwners").child("properties").child(Auth.auth().currentUser!.uid).child(propertyID).child("tenants").child(tenant.id).updateChildValues(["name": name, "lastname" : lastname, "email" : email, "phone": phone])
        isEditMode = false
    }

    func deleteTenant() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("PropertyOwners").child("properties").child(Auth.auth().currentUser!.uid).child(propertyID).child("tenants").child(tenant.id).removeValue()
        presentationMode.wrappedValue.dismiss()
    }
}

struct TenantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let id = "1234"
        let tenant = TenantModel(id: "1234", name: "Kalle", lastname: "Lassson", email: "email", phone: "98765")
        TenantDetailView(tenant: tenant, propertyID: id)
    }
}
