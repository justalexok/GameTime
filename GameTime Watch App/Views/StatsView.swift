//
//  StatsView.swift
//  GameTime Watch App
//
//  Created by Alex Goulder on 06/08/2024.
//

import SwiftUI

struct IconLabelView: View {
    let imageName: String
    let labelText: String
    let isSystemImage: Bool
    
    var body: some View {
        HStack {
            if isSystemImage {
                Image(systemName: imageName)
                    .foregroundColor(.mainRed)
            } else {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20) // Adjust the size as needed
            }
            
            Text(labelText)
                .font(.system(size: 10))
                .foregroundColor(.white)
                .opacity(0.7)
        }
    }
}

struct IconLabelView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IconLabelView(imageName: "figure.walk", labelText: "Steps", isSystemImage: true)
                .background(Color.black) // Just to see the white text clearly
                .previewLayout(.sizeThatFits)
            
            IconLabelView(imageName: "custom_image", labelText: "Custom Image", isSystemImage: false)
                .background(Color.black) // Just to see the white text clearly
                .previewLayout(.sizeThatFits)
        }
    }
}

