//
//  InputfieldView.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-10.
//

import SwiftUI

struct InputfieldView: View {
    
    @Binding var inputtext : String
    
    var imageName : String
    var placeholderTxt : String
    var keyType : UIKeyboardType
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            if inputtext.isEmpty {
                HStack {
                    Image(systemName: imageName).foregroundColor(.white)
                    Text(placeholderTxt)
                    .foregroundColor(.white )
                    .font(.body)
                    
                }.padding(.leading)
            }
            TextField("", text: $inputtext)
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(.system(size: 18))
                .padding()
                .keyboardType(keyType)
                .foregroundColor(.white)
                .overlay(RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white,  lineWidth: 2)
                )
        }.padding(.top,10)
    }
}

/*

struct InputfieldView_Previews: PreviewProvider {
    static var previews: some View {
        
        InputfieldView(phone: pho)
    }
}
*/
