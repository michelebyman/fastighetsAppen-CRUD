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
                        TextField("Email", text: $email)
                            .font(.body)
                            .padding()
                        SecureField("Password", text: $password)
                            .font(.body)
                            .padding()
                        if isError { Text("\(errorMessage)") }
                        Button(action: signIn) {
                            Text("Login")
                                .foregroundColor(Color(.white))
                                .frame(maxWidth: .infinity, minHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        .background(Color(.systemPink))
                        .cornerRadius(25)
                        .padding()
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
                if (Auth.auth().currentUser == nil) {
                    print("----------------------USer is not loggedin",Auth.auth().currentUser)
                    isLoggedIn = false
                    
                } else {
                    print("----------------------USer is loggedin-------------",Auth.auth().currentUser)
                    if let user = Auth.auth().currentUser {
                        print("user id --------->",user.uid)
                       
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
