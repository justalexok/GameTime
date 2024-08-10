//
//  InfoView.swift
//  GameTime Watch App
//
//  Created by Alex Goulder on 06/08/2024.
//

import SwiftUI

struct InfoView: View {
    let firstText: String
    let secondText: String
    
    var body: some View {
        VStack {
            Text(firstText)
                .font(.system(size: 10))
                .foregroundColor(.white)
                .opacity(0.55)
            
            Text(secondText)
                .font(.system(size: 17))
                .foregroundColor(.white)
                .opacity(0.55)
        }
    }
}
