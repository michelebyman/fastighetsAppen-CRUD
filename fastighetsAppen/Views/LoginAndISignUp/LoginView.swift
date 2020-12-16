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
                    .frame(height: 300)
                    .padding(.bottom, 20)
                    VStack {

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

                        
                        if isError { Text("\(errorMessage)").padding() }

                        ButtonView(text: "Login", backgroundColor: Color("buttonColor"), action: {signIn()}, isDisabled: email.isEmpty || password.isEmpty)

                        HStack {
                            Text("New here?").foregroundColor(.white).opacity(0.6).font(.callout)
                            NavigationLink(destination: SignUpView()) {
                                Text("Create an account").font(.callout).foregroundColor(.white)
                            }
                        }

                        .padding(.bottom, 50)
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
