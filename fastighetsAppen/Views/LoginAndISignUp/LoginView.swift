//
//  LoginView.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-04.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode

//    Login
    @State var email = ""
    @State var password = ""
    @State var isError = false
    @State var isLoginSheet = false
    @State var errorMessage = ""
    @State var isLoggedIn = true

//    Login and Create
    @State var showPassword = false

//    Reset password
    @State var emailToReset = ""
    @State var resetEmail = false
    @State var resetPasswordErrorMessage = ""
    @State var resetPasswordError = false



//    create account
    @State var isCreateAccountSheet = false
    @State var createAccount = false
    @State var name = ""
    @State var isErrorSigningIn = false
    

    var startCheckLogin = {}

    var body: some View {
        NavigationView {
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
                        .frame(height: 200)
                        .padding(.bottom, 20)
                        VStack {
                            if !resetEmail {
                                ButtonView(text: "Login", backgroundColor: Color("buttonColor"), action: {isLoginSheet = true})
                                HStack {
                                    Text("New Here?").foregroundColor(.white).opacity(0.6).font(.callout)
                                    Button(action: openCreateSheet) {
                                        Text("Create An Account").font(.callout).foregroundColor(.white)
                                    }
                                }
                            }
                            if isError { Text("\(errorMessage)").padding() }
                            Button(action: {
                                resetEmail.toggle()
                            }) {
                                Text(resetEmail ? "Login" : "Reset password" ).foregroundColor(.gray).font(.caption)
                            }.padding(.top, 10)

                        }
                        .fullScreenCover(isPresented: $isLoggedIn, content: {
                            PropertyOwnerHomeView()
                        })
                    }
                }
                .sheet(isPresented: $resetEmail, content: {
                    ZStack {
                        Color("backgroundColor")
                        VStack {
                            HStack {
                                Button(action: {resetEmail.toggle()}) {
                                    Text("Cancel")
                                }
                                Spacer()
                                Text("Reset Password").font(.body).fontWeight(.semibold)
                                Spacer()
                                Button(action: resetPassword) {
                                    Text("Reset")
                                }.disabled(email.isEmpty)

                            }.padding()

                            Spacer()
                            InputfieldView(inputText: $email, imageName: "envelope", placeholderText: "Email", keyboardType: .emailAddress)
                            if resetPasswordError { Text("\(resetPasswordErrorMessage)").padding() }
                            Spacer()
                        }
                    }
                })
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
        }.sheet(isPresented: createAccount ? $isCreateAccountSheet  : $isLoginSheet, content: {
            ZStack {
                Color("backgroundColor")
                VStack {
                    HStack {
                        Button(action: createAccount ? {createAccount.toggle()} : {isLoginSheet.toggle()} ) {
                            Text("Cancel")
                        }
                        Spacer()
                        Text(createAccount ? "Create Account"  : "Login").font(.body).fontWeight(.semibold)
                        Spacer()
                        Button(action: createAccount ? signUp :  signIn ) {
                            Text(createAccount ? "Create" : "Login")
                        }.disabled(email.isEmpty || password.isEmpty)

                    }.padding()

                    Spacer()
                    if createAccount {
                        InputfieldView(inputText: $name, imageName: "person", placeholderText: "Name", keyboardType: .default)
                    }
                    InputfieldView(inputText: $email, imageName: "envelope", placeholderText: "Email", keyboardType: .emailAddress)
                    PasswordTextfieldView(password: $password, showPassword: $showPassword)


                    Spacer()
                }
            }
        })
    }


    func openCreateSheet() {
        createAccount.toggle()
        isCreateAccountSheet = true
    }



    func resetTexfields() {
        name = ""
        email = ""
        password = ""
    }


    func savePropertyOwner() {
        if name == "" { return }

        let newUser = PropertyOwner(name: name)
        newUser.savePropertyOwner() {
            DispatchQueue.main.async {
                startCheckLogin()
            }

        }
        isCreateAccountSheet = false
        resetTexfields()
    }

    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password, completion: {
            signUpResult, SignUpError in
            if (SignUpError == nil) {
                savePropertyOwner()
            } else {
                errorMessage = (SignUpError?.localizedDescription ?? "")
                isErrorSigningIn = true

            }
        })

    }

    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            resetPasswordErrorMessage =  error!.localizedDescription
            resetPasswordError = true
            resetTexfields()
            
        }
    }
    
    func signIn() {

        Auth.auth().signIn(withEmail: email, password: password, completion: {
            loginResult, loginError in
            if (loginError == nil) {
                isLoggedIn = true
                isLoginSheet = false
                resetTexfields()
                //presentationMode.wrappedValue.dismiss()
                startCheckLogin()
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
