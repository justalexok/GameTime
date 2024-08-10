//
//  GameView.swift
//  GameTime Watch App
//
//  Created by Alex Goulder on 09/08/2024.
//

import SwiftUI

struct GameView: View {
    
    @State private var extendedRuntimeSession: WKExtendedRuntimeSession?
    @Binding var viewState: ViewState
    @Binding var isNewGame: Bool
    
    @State private var timerRunning = false
    @State private var timeString = "00:00"
    @State private var timeElapsed = 0
    @State private var firstHalfElapsed = 0
    @State private var halfTimeElapsed = 0
    @State private var secondHalfElapsed = 0
    @State private var backRestartIcon = "chevron.left"
    @State private var backIcon = "chevron.left"
    @State private var playPauseIcon = "play.fill"
    @State private var stateTitle = GameState.firstHalf.description
    @State private var gameState: GameState = .preKO
    @State private var nextStateBtnTitle = GameState.firstHalf.nextState
    
    @State private var heartRate: Double = 0.0
    @State private var isAuthorized = false
    
    @State private var isVisible = true
    @State private var showTimeEditorPopup = false
    @State private var gameStateToEdit: GameState = .firstHalf
    @State private var editedMinutes: Int = 0

    @State var activeGame: ActiveGameDates?
    @State var completedGame: Game?
    
    //    let healthKitManager = HealthKitManager()
    
    var body: some View {
        ZStack {
            VStack (spacing: 8) {
                Spacer(minLength: 20)
                
                //Info
                HStack (spacing:50) {
                    InfoView(firstText: "First Half", secondText: convertTimeToString(time: firstHalfElapsed))
                        .onLongPressGesture {
                            if gameState != .preKO {
                                withAnimation {
                                    showTimeEditorPopup = true
                                    gameStateToEdit = .firstHalf
                                }
                            }
                        }
                    InfoView(firstText: "Half Time", secondText: convertTimeToString(time: halfTimeElapsed))
                        .onLongPressGesture {
                            
                            if gameState != .preKO && gameState != .firstHalf {
                                withAnimation {
                                    showTimeEditorPopup = true
                                    gameStateToEdit = .halfTime
                                }
                            }
                        }
                }
                //Divider
                Rectangle()
                    .fill(Color.mainRed)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                
                
                VStack {
                    //State Title Label
                    Text(stateTitle)
                        .font(.title3)
                        .foregroundColor(Color.white.opacity(0.85))
                    
                    // Time Label
                    Text(timeString)
                        .foregroundColor(Color(hex: Colours.greenHex))
                        .font(.system(size: 36))
                        .onLongPressGesture {
                            withAnimation {
                                showTimeEditorPopup = true
                                gameStateToEdit = gameState
                            }
                        }
                    
                    // HStack with buttons
                    HStack {
                        
                        ClearButton(systemIconName: $backRestartIcon, action: resetTimer)
                        TextButton(title: nextStateBtnTitle, action: nextStatePressed )
                        PrimaryButton(systemIconName: $playPauseIcon, action: playpausePressed)
                        
                    }
                }
                Spacer(minLength: 3)
                
                Rectangle()
                    .fill(Color.mainRed)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                
                
                //            HStack {
                //                IconLabelView(imageName: "heart", labelText: "171 BPM", isSystemImage: true)
                //                IconLabelView(imageName: "steps", labelText: "4783", isSystemImage: false)
                //
                //            }
                Spacer(minLength: 40)
                
                
                
            }
            .background(.black)
            .opacity(isVisible ? 1 : 0)
            .animation(.easeInOut(duration: 0.25), value: isVisible)
            
            // Popup view
            if showTimeEditorPopup {
                VStack {
                    Text("Edit Time")
                        .padding()
                        .cornerRadius(8)
                        .shadow(radius: 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Picker("Select a number", selection: $editedMinutes) {
                           ForEach(0..<101) { number in
                               Text("\(number):00").tag(number)

                                   .foregroundColor(editedMinutes == number ? .mainRed : .black)
                           }
                       }
                       .labelsHidden()
                       .frame(height: 85)
                       .clipped()
                       
        
                    HStack {
                        ClearButton(systemIconName: $backIcon,  action: {
                            withAnimation {
                                showTimeEditorPopup = false

                            }
                        })
                        
                        TextButton(title: "OK", width: 50, height: 15) {
                            withAnimation {
                                switch gameStateToEdit {
                                case .preKO:
                                    firstHalfElapsed = editedMinutes * 60
                                    timeString = convertTimeToString(time: firstHalfElapsed)
                                case .firstHalf:
                                    firstHalfElapsed = editedMinutes * 60
                                    timeString = convertTimeToString(time: firstHalfElapsed)
                                case .halfTime:
                                    halfTimeElapsed = editedMinutes * 60
                                    timeString = convertTimeToString(time: halfTimeElapsed)
                                case .secondHalf:
                                    secondHalfElapsed = editedMinutes * 60
                                    timeString = convertTimeToString(time: secondHalfElapsed)

                                case .fullTime:
                                    break
                                }
                                showTimeEditorPopup = false

                                
                            }
                        }
                       
                        .padding()
                        .background(.mainRed)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(.mainCharcoal)
                .cornerRadius(10)
                .shadow(radius: 10)
                .transition(.scale)
            }
            
        }
        
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            if !isNewGame {
                handleActiveGameLaunch()
            }
        }

        
    }
    
    func handleActiveGameLaunch() {
        
        guard let retreivedGame = UserDefaults.standard.loadActiveGame() else {
            return
        }
            
        activeGame = retreivedGame
        
        gameState = retreivedGame.gameState
        activeGame?.gameState = gameState
        stateTitle = gameState.description
        backRestartIcon = "arrow.clockwise"
        nextStateBtnTitle = gameState.nextState
        
        switch retreivedGame.gameState {
            
        case .preKO:
            break
        case .firstHalf:
            firstHalfElapsed = Int( Date().timeIntervalSince(retreivedGame.lastSectionStart) )
            print("First Half. Time since began: \(firstHalfElapsed)")
            timeString = convertTimeToString(time: firstHalfElapsed)
            
        case .halfTime:
            firstHalfElapsed = retreivedGame.completedFirstHalfLength
            halfTimeElapsed = Int(Date().timeIntervalSince(retreivedGame.lastSectionStart))
            print("Half Time. Time since began: \(halfTimeElapsed)")
            timeString = convertTimeToString(time: halfTimeElapsed)


        case .secondHalf:
            
            print(activeGame?.lastSectionStart)

            firstHalfElapsed = retreivedGame.completedFirstHalfLength
            halfTimeElapsed = retreivedGame.completedHalfTimeLength
            secondHalfElapsed = Int(Date().timeIntervalSince(retreivedGame.lastSectionStart))
            timeString = convertTimeToString(time: secondHalfElapsed)

        case .fullTime:
            break
        }
    
        playpausePressed()
    }
    
    
    func playpausePressed() {
        
        timerRunning.toggle()
        
        playPauseIcon = timerRunning ? "pause.fill" : "play.fill"
        
        if timerRunning {
            updateTimer()
        }
        
        if gameState == .preKO {
            nextStatePressed()
        }
    }
    
    func updateTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.timerRunning {
                
                self.updateTimeString()
                
            } else {
                timer.invalidate()
            }
        }
    }
    
    func nextStatePressed() {
        
        // Start the fade-out animation
        withAnimation {
            isVisible = false
        }
        
        // Delay for 0.1 seconds, then trigger the fade-in animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation {
                isVisible = true
                if gameState != .secondHalf { timeString = "00:00" }
            }
        }
        
        switch gameState {
        case .preKO:
            activeGame = ActiveGameDates()
            gameState = .firstHalf
            backRestartIcon = "arrow.clockwise"
            activeGame?.lastSectionStart = Date()
            activeGame?.gameState = gameState
            UserDefaults.standard.saveActiveGame(activeGame!)
        case .firstHalf:
            gameState = .halfTime
            activeGame?.lastSectionStart = Date()
            activeGame?.completedFirstHalfLength = firstHalfElapsed
            activeGame?.gameState = gameState
            UserDefaults.standard.saveActiveGame(activeGame!)
        case .halfTime:
            gameState = .secondHalf
            activeGame?.lastSectionStart = Date()
            activeGame?.completedHalfTimeLength = halfTimeElapsed
            activeGame?.gameState = gameState
            UserDefaults.standard.saveActiveGame(activeGame!)
        case .secondHalf:
            gameState = .fullTime
            completedGame = Game(firstHalfLength: firstHalfElapsed, secondHalfLength: secondHalfElapsed, halfTimeLength: halfTimeElapsed)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                if let completedGame {
                    viewState = .summary(gameData: completedGame)
                }
            }
        case .fullTime:
            break
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.125) {
            stateTitle = gameState.description
            nextStateBtnTitle = gameState.nextState
        }
        
        
        if !timerRunning {
            timerRunning = true
            playPauseIcon = "pause.fill"
            updateTimer()
        }
    }
  
    
    func resetTimer() {
        
        activeGame?.lastSectionStart = Date()
        activeGame?.gameState = gameState
        UserDefaults.standard.saveActiveGame(activeGame!)
        
        timerRunning = false
        
        switch gameState {
        case .preKO:
            viewState = .home
        case .firstHalf:
            firstHalfElapsed = 0
        case .halfTime:
            halfTimeElapsed = 0
        case .secondHalf:
            secondHalfElapsed = 0
        case .fullTime:
            break
        }
        timeString = convertTimeToString(time: 0)
        playPauseIcon = "play.fill"
    }
    
    
    func updateTimeString() {
        
        switch gameState {
        case .preKO:
            firstHalfElapsed += 1
            timeString = convertTimeToString(time: firstHalfElapsed)
        case .firstHalf:
            firstHalfElapsed += 1
            timeString = convertTimeToString(time: firstHalfElapsed)
        case .halfTime:
            halfTimeElapsed += 1
            timeString = convertTimeToString(time: halfTimeElapsed)
        case .secondHalf:
            secondHalfElapsed += 1
            timeString = convertTimeToString(time: secondHalfElapsed)
        case .fullTime:
            break
        }
        
    }
}
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        @State var previewViewState: ViewState = .home
        @State var isNewGame: Bool = false
        GameView(viewState: $previewViewState, isNewGame: $isNewGame)
    }
}

import WatchKit

class InterfaceController: WKInterfaceController, WKExtendedRuntimeSessionDelegate {
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        //
    }
    
    
    var extendedRuntimeSession: WKExtendedRuntimeSession?
    var timer: Timer?
    var elapsedTime: TimeInterval = 0
    
    override func willActivate() {
        super.willActivate()
        
        startExtendedRuntimeSession()
    }
    
    func startExtendedRuntimeSession() {
        extendedRuntimeSession = WKExtendedRuntimeSession()
        extendedRuntimeSession?.delegate = self
        extendedRuntimeSession?.start()
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Extended runtime session started.")
        startTimer()
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Extended runtime session will expire soon.")
    }
    
    func extendedRuntimeSessionDidInvalidate(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Extended runtime session ended.")
        stopTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedTime += 1
            print("Elapsed time: \(self.elapsedTime) seconds")
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
}


import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    func applicationDidFinishLaunching() {
        // Schedule a background refresh task
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(timeIntervalSinceNow: 15 * 60), userInfo: nil) { (error) in
            if let error = error {
                print("Error scheduling background refresh: \(error)")
            }
        }
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            if let refreshTask = task as? WKApplicationRefreshBackgroundTask {
                // Perform the background task
                performBackgroundTask()
                
                // Schedule the next background refresh
                WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(timeIntervalSinceNow: 15 * 60), userInfo: nil) { (error) in
                    if let error = error {
                        print("Error scheduling next background refresh: \(error)")
                    }
                }
                
                // Mark the task as completed
                refreshTask.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    func performBackgroundTask() {
        // Your background task logic here
        print("Background task running...")
    }
}

