//
//  fastighetsAppenApp.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-04.
//

import SwiftUI
import Firebase

@main
struct fastighetsAppenApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            PropertyOwnerHomeView()
        }
    }
}
