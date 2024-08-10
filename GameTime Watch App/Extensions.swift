//
//  Extensions.swift
//  GameTime Watch App
//
//  Created by Alex Goulder on 06/08/2024.
//

import SwiftUI

extension Font {
    static func mainFont(size: CGFloat) -> Font {
        return .custom("Kufam-VariableFont_wght", size: size)
    }
}

import Foundation

extension UserDefaults {
    private enum Keys {
        static let completedGames = "completedGames"
        static let activeGame = "activeGame"
    }
    
    func saveGame(_ game: Game) {
        var games = loadGames() ?? []
        games.append(game)
        if let encoded = try? JSONEncoder().encode(games) {
            set(encoded, forKey: Keys.completedGames)
        }
    }
    
    func loadGames() -> [Game]? {
        if let savedGameData = data(forKey: Keys.completedGames) {
            if let decodedGames = try? JSONDecoder().decode([Game].self, from: savedGameData) {
                return decodedGames
            }
        }
        return nil
    }
    
    func saveActiveGame(_ game: ActiveGameDates) {
        if let encoded = try? JSONEncoder().encode(game) {
            set(encoded, forKey: Keys.activeGame)
        }
    }
    
    func loadActiveGame() -> ActiveGameDates? {
        if let savedGameData = data(forKey: Keys.activeGame) {
            if let decodedGame = try? JSONDecoder().decode(ActiveGameDates.self, from: savedGameData) {
                return decodedGame
            }
        }
        return nil
    }
}
// Extend the Date type to include the dateFormatted method
extension Date {
    func dateFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: self)
    }
}

