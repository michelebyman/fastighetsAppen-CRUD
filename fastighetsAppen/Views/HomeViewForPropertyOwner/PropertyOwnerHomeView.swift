//
//  PropertyOwnerHomeView.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-06.
//

import SwiftUI
import Firebase

struct PropertyOwnerHomeView: View {
    @State var isSignedOut = false
    @State var activeUser = false
    @State var user = Auth.auth().currentUser
    
    var body: some View {
        NavigationView{
            ZStack{
                Color("backgroundColor")
                    .ignoresSafeArea(.all)
             
                    AddProperty()
             
                .navigationBarItems(trailing: Button(action: signOut) {
                    Text("Sign out")
                    
                }
                .fullScreenCover(isPresented: $isSignedOut, content: {
                    LoginView()
                })
                )
            }
            
        }
        .onAppear() {
            if (Auth.auth().currentUser == nil) {
                print("----------------------USer is not loggedin",Auth.auth().currentUser!)
                isSignedOut = false

            }
        }
        .accentColor(.pink)
    }
    
    func signOut()  {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            isSignedOut = true
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    

    
}

struct PropertyOwnerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyOwnerHomeView()
    }
}
