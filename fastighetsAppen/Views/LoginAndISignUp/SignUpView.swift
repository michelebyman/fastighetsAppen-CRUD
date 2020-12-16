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
            VStack {
                VStack {
                        ZStack {
                            Image("background1024")
                                .resizable()
                                .padding(.top, -150)
                        }
                        .frame(height: 250)
                        .padding(.bottom, 20)

                    InputfieldView(inputText: $name, imageName: "person", placeholderText: "Name", keyboardType: .default)
                    InputfieldView(inputText: $email, imageName: "envelope", placeholderText: "Email", keyboardType: .emailAddress)
                    PasswordTextfieldView(password: $password, showPassword: $showPassword)
                    
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





