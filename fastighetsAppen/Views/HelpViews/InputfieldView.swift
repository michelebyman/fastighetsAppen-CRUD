//
//  InputfieldView.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-10.
//

import SwiftUI

struct InputfieldView: View {
    
    @Binding var inputText : String
    
    var imageName : String
    var placeholderText : String
    var keyboardType : UIKeyboardType
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            if inputText.isEmpty {
                HStack {
                    Image(systemName: imageName).foregroundColor(.white)
                    Text(placeholderText)
                    .foregroundColor(.white )
                    .font(.body)
                    
                }.padding(.leading)
                
            }
            TextField("", text: $inputText)
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(.body)
                .padding()
                .keyboardType(keyboardType)
                .foregroundColor(.white)
                .overlay(RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white,  lineWidth: 2)
                )
        }
        
        .padding(.bottom, 20)
        .padding(.horizontal)
        
    }
}

/*

struct InputfieldView_Previews: PreviewProvider {
    static var previews: some View {
        
        InputfieldView(phone: pho)
    }
}
*/
