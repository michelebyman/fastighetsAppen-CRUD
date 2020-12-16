//
//  ButtonView.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-16.
//


import SwiftUI
struct ButtonView: View {
    var text: String
    var imageName: String = ""
    var backgroundColor: Color
    var action: () -> Void
    var isDisabled = false
    var foregroundColor: Color = .white
    var paddingLeadingTrailing: CGFloat = 50


    var body: some View {
            Button(action: action , label: {
                HStack {
                    Spacer()
                    if (!imageName.isEmpty) {
                        Image(systemName: imageName)
                            .font(.body)
                    }
                    Text(text).font(.body)
                    Spacer()
                }
                .padding()
                .foregroundColor(foregroundColor)
                .background(!isDisabled ? backgroundColor : Color(.gray))
            })
            .cornerRadius(15)
            .padding([.top, .bottom], 20)
            .padding([.trailing, .leading], paddingLeadingTrailing)
            .disabled(isDisabled)
        }

    }

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "Some Button", imageName: "play.fill", backgroundColor: Color(.red)) {
            print("Tapped")
        }
    }
}

