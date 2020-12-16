//
//  PasswordTextfieldView.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-16.
//

import SwiftUI

struct PasswordTextfieldView: View {
    @Binding var password: String
    @Binding var showPassword: Bool

    var body: some View {
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
    }
}

struct PasswordTextfieldView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordTextfieldView(password: .constant("pass"), showPassword: .constant(true))
    }
}
