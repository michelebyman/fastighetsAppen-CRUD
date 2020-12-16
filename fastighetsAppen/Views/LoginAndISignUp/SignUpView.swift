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
                    .frame(height: 400)
                    .padding(.top, -100)
                    .padding(.bottom, 50)

                    InputfieldView(inputText: $name, imageName: "person", placeholderText: "Name", keyboardType: .default)
                    InputfieldView(inputText: $email, imageName: "envelope", placeholderText: "Email", keyboardType: .emailAddress)
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(Color("inputColor"))
                            .frame(height: 50)
                        if password.isEmpty {
                            HStack {
                                Image(systemName: "lock")
                                Text("Password")
                                    .font(.body)
                            }
                            .foregroundColor(.white )
                            .padding(.horizontal)
                        }
                        HStack {
                            if showPassword {
                                TextField("", text: $password)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .font(.body )
                                    .padding()
                                    .keyboardType(.default)
                                
                            } else {
                                SecureField("", text: $password)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .font(.body)
                                    .padding()
                                    .keyboardType(.default)
                            }
                            Spacer()
                            if !password.isEmpty {
                                Button(action: {showPassword.toggle()}) {
                                    Image(systemName: showPassword ? "eye" : "eye.slash")
                                        .padding(.trailing)
                                }
                            }
                            
                        }
                        .frame(height: 50)
                        .foregroundColor(.white)
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal)
                    if isErrorSigningIn {Text("\(errorMessage)")}
                    ButtonView(text: "Sign up", backgroundColor: Color("buttonColor"), action: {signUp()}, isDisabled: name.isEmpty || email.isEmpty || password.isEmpty, foregroundColor: Color(.white))
                    Spacer()
                }.fullScreenCover(isPresented: $isLoggedIn, content: {
                    PropertyOwnerHomeView()
                })
                Spacer()

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





