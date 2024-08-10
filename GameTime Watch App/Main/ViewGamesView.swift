//
//  ViewGamesView.swift
//  GameTime Watch App
//
//  Created by Alex Goulder on 09/08/2024.
//

import SwiftUI

struct ViewGamesView: View {
    
    @Binding var viewState: ViewState
    @State private var games: [Game] = []

    var body: some View {
        VStack(spacing: 5) {

            if !games.isEmpty {
                
                List(games) { game in
                    HStack {
                        Text(game.date.dateFormatted())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.footnote)
                            .opacity(0.65)
                        
                        Text(convertTimeToString(time: game.firstHalfLength + game.secondHalfLength))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                        
                    }
                    .padding(10)
                    .background(.mainCharcoal)
                    .cornerRadius(8)
                    .listRowBackground(Color.clear) // Remove the default background

                }
            } else {
                Text("No games available.")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            loadGames()
        }
        .navigationTitle("All Games") // Title for this view
        .navigationBarTitleDisplayMode(.inline) // Controls the display
    }
    private func loadGames() {
        if let loadedGames = UserDefaults.standard.loadGames() {
            games = loadedGames.sorted(by: { $0.date > $1.date })
        } else {
            games = []
        }
        print(games.count)
    }
}
