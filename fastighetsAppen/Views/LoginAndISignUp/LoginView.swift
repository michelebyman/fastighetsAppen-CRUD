//
//  LoginView.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-04.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var isError = false
    @State var errorMessage = ""
    @State var isLoggedIn = false
    @State var showPassword = false
    @State var emailToReset = ""
    @State var resetEmail = false
    
    
    var body: some View {
        NavigationView {
            ZStack{
                Color("backgroundColor")
                    .ignoresSafeArea(.all)

                VStack {
                    ZStack {
                        Image("background1024")
                            .resizable()
                            .padding(.top, -150)
                    }
                    .frame(height: 200)
                    .padding(.bottom, 20)
                    VStack {
                        InputfieldView(inputText: $email, imageName: "envelope", placeholderText: "Email", keyboardType: .emailAddress)
                        if !resetEmail {
                        PasswordTextfieldView(password: $password, showPassword: $showPassword)
                        if isError { Text("\(errorMessage)").padding() }
                        ButtonView(text: "Login", backgroundColor: Color("buttonColor"), action: {signIn()}, isDisabled: email.isEmpty || password.isEmpty)
                        HStack {
                            Text("New here?").foregroundColor(.white).opacity(0.6).font(.callout)
                            NavigationLink(destination: SignUpView()) {
                                Text("Create an account").font(.callout).foregroundColor(.white)
                            }
                        }
                        } else {
                            ButtonView(text: "Reset password", backgroundColor: Color("buttonColor"), action: {
                                Auth.auth().sendPasswordReset(withEmail: email) { error in                             print(error?.localizedDescription)                         }
                            }, isDisabled: email.isEmpty)
                        }
                        Button(action: {
                            resetEmail.toggle()
                        }) {
                            Text(resetEmail ? "Go to login" : "Reset password" ).foregroundColor(.gray).font(.caption)
                        }.padding(.top, 10)

                    }
                    .fullScreenCover(isPresented: $isLoggedIn, content: {
                        PropertyOwnerHomeView()
                    })
                }
            }
            .onAppear() {
                isError = false
                if (Auth.auth().currentUser == nil) {
                    isLoggedIn = false
                } else {
                    if Auth.auth().currentUser != nil {
                        isLoggedIn = true
                    }
                }
            }
        }

    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password, completion: {
            loginResult, loginError in
            if (loginError == nil) {
                isLoggedIn = true
            } else {
                errorMessage = loginError?.localizedDescription ?? ""
                isError = true
            }
        })
    }
    
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
