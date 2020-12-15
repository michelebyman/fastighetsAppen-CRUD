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
                ScrollView {
                    VStack {
                        ZStack {
                            Circle()
                                .foregroundColor(.green)
                            Circle()
                                .strokeBorder(Color.blue, lineWidth: 50)
                            HStack {
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                            }
                        }
                        .frame(width: 250, height: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding()
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
                                        .font(.body)
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
                                            .foregroundColor(.white)
                                            .padding(.trailing)
                                    }
                                }
                                
                            }
                            .foregroundColor(.white)

                          
                            
                        }
                        .padding(.bottom, 10)
                        .padding(.horizontal)
                        
                        if isError { Text("\(errorMessage)").padding() }
                        Button(action: signIn) {
                            Text("Login")
                                .foregroundColor(Color(.white))
                                .frame(maxWidth: .infinity, minHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        .background(Color("buttonColor"))
                        .cornerRadius(15)
                        .padding(.top, 10)
                        .padding([.trailing, .leading], 50)
                        .navigationBarItems(trailing: NavigationLink(
                                                destination: SignUpView(),
                                                label: {
                                                    Text("Register")
                                                        .frame(maxWidth: .infinity, minHeight: 50, alignment: .center)
                                                })
                        )
                        .navigationBarTitle("Login")
                    }.fullScreenCover(isPresented: $isLoggedIn, content: {
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
        .accentColor(.pink)
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
