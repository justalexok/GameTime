//
//  Game.swift
//  GameTime Watch App
//
//  Created by Alex Goulder on 07/08/2024.
//

import SwiftUI

struct Game: Codable, Identifiable {
 
    var id = UUID() // Unique identifier for each game
    var date = Date()
    var firstHalfLength = Int()
    var secondHalfLength = Int()
    var halfTimeLength = Int()
    var homeScore = Int()
    var awayScore = Int()
}

struct ActiveGameDates: Codable {
    
    var lastSectionStart = Date()
    
    var completedFirstHalfLength = Int()
    var completedHalfTimeLength = Int()

    var firstHalfPauseCounter = Int()
    var halfTimePauseCounter = Int()
    var secondHalfPauseCounter = Int()
    
    var gameState: GameState = .firstHalf
}
