//
//  SignUpView.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-04.
//

import SwiftUI
import Firebase


struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    @State var errorMessage = ""
    @State var isErrorSigningIn = false
    @State var isLoggedIn = false
    @State var isError = false
    @State var name = ""
    @State var showPassword = false
   

    var body: some View {
        ZStack{
            Color("backgroundColor")
                .ignoresSafeArea(.all)
            ScrollView {
                VStack {
                    Spacer()
                    ZStack {


                            Image("background")
                                .resizable()

                    }
                    .frame(width: .infinity, height: 400, alignment: .center)
                    .padding(.top, -100)
                    InputfieldView(inputText: $name, imageName: "person", placeholderText: "Name", keyboardType: .default)
                    InputfieldView(inputText: $email, imageName: "envelope", placeholderText: "Email", keyboardType: .emailAddress)
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        .fill(Color("inputColor"))
                        if password.isEmpty {
                            HStack {
                                Image(systemName: "lock").foregroundColor(.white)
                                Text("Password")
                                    .foregroundColor(.white )
                                    .font(.body)
                            }
                            .padding(.horizontal)
                        }
                        HStack {
                            if showPassword {
                                TextField("", text: $password)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .font(.system(size: 18))
                                    .padding()
                                    .keyboardType(.default)
                                
                            } else {
                                SecureField("", text: $password)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .font(.system(size: 18))
                                    .padding()
                                    .keyboardType(.default)
                            }
                            Spacer()
                            if !password.isEmpty {
                                Button(action: {showPassword.toggle()}) {
                                    Image(systemName: showPassword ? "eye" : "eye.slash")
                                        .foregroundColor(.white)
                                        .padding(.trailing)
                                }
                            }
                            
                        }.foregroundColor(.white)
                        
                        
                        
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal)
                    if isErrorSigningIn {Text("\(errorMessage)")}
                    Button(action: signUp) {
                        Text("Sign up")
                            .foregroundColor(Color(.white))
                            .frame(maxWidth: .infinity, minHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }

                    .background(Color("buttonColor"))
                    .cornerRadius(15)
                    .padding(.top, 10)
                    .padding([.trailing, .leading], 50)
                    Spacer()
                }.fullScreenCover(isPresented: $isLoggedIn, content: {
                    PropertyOwnerHomeView()
                })
                Spacer()
                    .navigationBarTitle("Register").foregroundColor(.white)
            }
        }
    }
    
    func savePropertyOwner() {
        if name == "" { return }
        let newUser = PropertyOwner(name: name)
        newUser.savePropertyOwner()
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password, completion: {
            signUpResult, SignUpError in
            if (SignUpError == nil) {
                if Auth.auth().currentUser != nil {
                    isLoggedIn = true
                }
                savePropertyOwner()
               
            } else {
                errorMessage = (SignUpError?.localizedDescription ?? "")
                isErrorSigningIn = true
            }
        })
    }
    
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}





