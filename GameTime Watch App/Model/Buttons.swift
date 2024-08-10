//
//  Buttons.swift
//  GameTime Watch App
//
//  Created by Alex Goulder on 06/08/2024.
//

import SwiftUI

struct ClearButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.clear)
    }
}


struct PrimaryButton: View {
    @Binding var systemIconName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemIconName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 20, height: 20) // Adjust the size as needed
                .padding()
                .frame(width: 52, height: 36)
                .background(.mainRed)
                .cornerRadius(5)

        }
        .buttonStyle(ClearButtonStyle())
    }
}

struct TextButton: View {
    let title: String
    let action: () -> Void
    let width: CGFloat
    let height: CGFloat
    
    init(title: String, width: CGFloat = 52, height: CGFloat = 36, action: @escaping () -> Void) {
            self.title = title
            self.action = action
            self.width = width
            self.height = height
        }
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: width, height: height)
                .background(.mainRed)
                .cornerRadius(5)
        }
        .buttonStyle(ClearButtonStyle())
    }
}
struct ClearTextButton: View {

    let title: String
    let action: () -> Void
    let width: CGFloat
    let height: CGFloat
    
    init(title: String, action: @escaping () -> Void, width: CGFloat = 52, height: CGFloat = 36) {
            self.title = title
            self.action = action
            self.width = width
            self.height = height
        }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.mainRed)
                .frame(width: width, height: height)
                .background(.mainCharcoal)
                .cornerRadius(5)
        }
        .buttonStyle(ClearButtonStyle())
    }
}


struct ClearButton: View {
    @Binding var systemIconName: String

    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemIconName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.mainRed)
                .frame(width: 20, height: 20) // Adjust the size as needed
                .padding()
                .frame(width: 52, height: 36)
                .background(.mainCharcoal)
                .cornerRadius(5)
                .font(.system(size: 20, weight: .bold)) // Apply bold weight


        }
        .buttonStyle(ClearButtonStyle())
    }
}


