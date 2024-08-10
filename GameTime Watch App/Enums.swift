//
//  Enums.swift
//  GameTime Watch App
//
//  Created by Alex Goulder on 06/08/2024.
//

import Foundation

enum ViewState {
    case home
    case viewGames
    case game
    case summary (gameData: Game)
}

enum GameState: Codable {
    case preKO, firstHalf, halfTime, secondHalf, fullTime

    var description: String {
        switch self {
        case .preKO:
            return "First Half"
        case .firstHalf:
            return "First Half"
        case .halfTime:
            return "Half Time"
        case .secondHalf:
            return "Second Half"
        case .fullTime:
            return "Full Time"
        }
        
    }
    var nextState: String {
        switch self {
        case .preKO:
            return "KO"
        case .firstHalf:
            return "HT"
        case .halfTime:
            return "2H"
        case .secondHalf:
            return "FT"
        case .fullTime:
            return "FT"
        }
    }
}
