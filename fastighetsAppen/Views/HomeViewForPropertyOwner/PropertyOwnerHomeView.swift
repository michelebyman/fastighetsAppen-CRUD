//
//  PropertyOwnerHomeView.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-06.
//

import SwiftUI
import Firebase

struct PropertyOwnerHomeView: View {
    @State var isSignedOut = true
    @State var user = Auth.auth().currentUser
    
    var body: some View {
        NavigationView{
            ZStack{
                Color("backgroundColor")
                    .ignoresSafeArea(.all)
                if isSignedOut == false {
                    VStack {
                        AddProperty()
                        ButtonView(text: "Sign out",backgroundColor: Color("secondaryButtonText"), action: { signOut()})
                    }
                }

            }
            
        }
        .fullScreenCover(isPresented: $isSignedOut, content: {
            LoginView(startCheckLogin: {
                if (Auth.auth().currentUser == nil) {
                    print("USER NOW NOT LOGGED IN")
                    isSignedOut = true
                } else {
                    print("USER NOW LOGGED IN")
                    isSignedOut = false
                }
            })
        })
        .onAppear() {

            if (Auth.auth().currentUser == nil) {
                print("USER NOW NOT LOGGED IN")
                isSignedOut = true
            } else {
                print("USER NOW LOGGED IN")
                isSignedOut = false
            }
        }

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
