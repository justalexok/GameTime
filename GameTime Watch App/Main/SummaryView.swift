//
//  SummaryView.swift
//  GameTime Watch App
//
//  Created by Alex Goulder on 06/08/2024.
//

import SwiftUI

struct SummaryView: View {
    
    @Binding var viewState: ViewState

    @State var completedGame: Game
    @State private var firstPickerSelection: Int = 0
    @State private var secondPickerSelection: Int = 0



    var body: some View {
        VStack {
            // Top section with Summary text
            Text("Summary")
                .foregroundColor(Color.white.opacity(0.85))
                .font(.headline)

            // Middle section with swiping views
            TabView {
                VStack {
                    HStack (spacing: 25) {
                        InfoView(firstText: "First Half", secondText: convertTimeToString(time: completedGame.firstHalfLength))
                        InfoView(firstText: "Second Half", secondText: convertTimeToString(time: completedGame.secondHalfLength))
                    }
                    .padding()

                    VStack {
                        Text("Total Game Time")
                            .font(.headline)
                        Text("\(convertTimeToString(time: (completedGame.firstHalfLength + completedGame.secondHalfLength)))")
                            .foregroundColor(.mainGreen)
                            .font(.largeTitle)
                    }
                }
                .tabItem { Text("Game Times") }

                VStack {
                    Text("Score")
                    HStack {
                        Picker("", selection: $firstPickerSelection) {
                            ForEach(0...20, id: \.self) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: 70)
                        .frame(height: 60)
                        .clipped()

                        Picker("", selection: $secondPickerSelection) {
                            ForEach(0...20, id: \.self) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: 70)
                        .frame(height: 60)
                        .clipped()
                    }
                }
                .padding()
                .tabItem { Text("Score") }
                
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 120) // Adjust height as needed
            .background(.mainCharcoal) // Optional background color for clarity
            .cornerRadius(10)
            .padding()

            // Bottom section with Home and Save buttons
            HStack(spacing: 10) {
                let width: CGFloat = 70
                ClearTextButton(title: "Home", action: {
                    viewState = .home
                }, width: width)

                TextButton(title: "Save", width: width, action: {
                    saveCompletedGame()
                    viewState = .home
                })
            }
            .padding(.bottom)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }


    
    func saveCompletedGame() {
        completedGame.date = Date()
        completedGame.homeScore = firstPickerSelection
        completedGame.awayScore = secondPickerSelection
        UserDefaults.standard.saveGame(completedGame)
        
    }
    
}
struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var previewViewState: ViewState = .summary(gameData: Game())
        SummaryView(viewState: $previewViewState, completedGame: Game())
    }
}
