import SwiftUI

struct HomeView: View {
    @Binding var viewState: ViewState
    @Binding var isNewGame: Bool
    @State private var isButtonDisabled: Bool = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // View Games Button
                NavigationLink(destination: ViewGamesView(viewState: $viewState)) {
                    Text("View Games")
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .padding()
                        .background(Color.mainCharcoal)
                        .cornerRadius(15)
                }
                .buttonStyle(ClearButtonStyle())
                
                // New Game Button
                Button(action: {
                    if let activeGame = UserDefaults.standard.loadActiveGame() {
                        viewState = .game
                        isNewGame = false
                    }
                    
                }, label: {
                    Text("Load Active Game")
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .padding()
                        .background(Color.mainCharcoal)
                        .cornerRadius(15)
                    
                })
                .buttonStyle(ClearButtonStyle())
                .disabled(isButtonDisabled)
                .onAppear {
                    // Check if there's an active game and update the button's disabled state
                    if UserDefaults.standard.loadActiveGame() != nil {
                        isButtonDisabled = false
                    } else {
                        isButtonDisabled = true
                    }
                }
                
                // New Game Button
                Button(action: {
                    viewState = .game
                    isNewGame = true
                }, label: {
                    Text("New Game")
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .padding()
                        .background(Color.mainRed)
                        .cornerRadius(15)
                })
                .buttonStyle(ClearButtonStyle())
                
                // Additional content can go here
            }
            .padding()
        }
    }
}
