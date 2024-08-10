//
//  Time.swift
//  GameTime Watch App
//
//  Created by Alex Goulder on 07/08/2024.
//

import Foundation

func convertTimeToString(time: Int) -> String {
    let minutes = time/60
    let seconds = time%60
    return String(format: "%02d:%02d", minutes, seconds)
}
