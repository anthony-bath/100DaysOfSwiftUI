//
//  ContentView.swift
//  RockPaperScissorsBrainTraining
//
//  Created by Anthony Bath on 4/19/23.
//

import SwiftUI

struct ContentView: View {
    @State private var choices = ["👊","✌️","✋"]
    @State private var shouldWin = Bool.random();
    @State private var selected = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var roundsPlayed = 0
    @State private var showingGameEnded = false

    var body: some View {
        ZStack {
            Color(red: 0.12, green: 0.18, blue: 0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer()
                
                Text("Brain Training")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("\(shouldWin ? "Win" : "Lose") against")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 24))
                            .bold()
                        
                        Text(choices[selected])
                            .font(.system(size: 36))
                    }
                    .padding(.bottom, 30)
                    
                    
                    ForEach(0..<3) { number in
                        Button(choices[number]) {
                            onSelectAnswer(answer: number)
                        }
                        .clipShape(Circle())
                        .buttonStyle(.bordered)
                        .font(.system(size: 80))
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(
                                    Color.black,
                                    style: StrokeStyle(lineWidth: 5, dash: [1])
                                )
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
            }
            .padding(.horizontal, 50)
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: prepareNextRound)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game Ended", isPresented: $showingGameEnded) {
            Button("Play Again", action: startOver)
        } message: {
            Text("You scored \(score) out of 10!")
        }
    }
    
    func onSelectAnswer(answer: Int) {
        let selected: String = choices[selected]
        let player: String = choices[answer]
        let correctAnswer: String
        
        if (shouldWin) {
            switch (selected) {
            case "👊": correctAnswer = "✋"
            case "✋": correctAnswer = "✌️"
            case "✌️": correctAnswer = "👊"
            default: correctAnswer = ""
            }
        } else {
            switch (selected) {
            case "👊": correctAnswer = "✌️"
            case "✋": correctAnswer = "👊"
            case "✌️": correctAnswer = "✋"
            default: correctAnswer = ""
            }
        }
        
        if (player == correctAnswer) {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong - correct was \(correctAnswer)"
        }
        
        roundsPlayed += 1
        showingScore = true
    }
    
    func prepareNextRound() {
        if (roundsPlayed == 10) {
            showingGameEnded = true
        } else {
            shouldWin = Bool.random()
            selected = Int.random(in: 0...2)
            choices.shuffle()
        }
    }
    
    func startOver() {
        score = 0
        roundsPlayed = 0
        prepareNextRound()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
