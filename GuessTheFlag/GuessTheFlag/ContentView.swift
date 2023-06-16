//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Anthony Bath on 4/14/23.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    var description: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
            .accessibilityLabel(description)
    }
}

struct ContentView: View {
    @State private var canTap = true
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionsAnswered = 0
    @State private var showingGameEnded = false
    @State private var animationAmounts = [0.0, 0.0, 0.0]
    @State private var opacity = [1.0, 1.0, 1.0]
    @State private var scale = [1.0, 1.0, 1.0]
    
    @State private var countries = [
        "Estonia",
        "France",
        "Germany",
        "Ireland",
        "Italy",
        "Nigeria",
        "Poland",
        "Russia",
        "Spain",
        "UK",
        "US"
    ].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            if (canTap) {
                                flagTapped(number)
                                
                                for i in 0..<3 {
                                    withAnimation {
                                        opacity[i] = i == number ? 1.0 : 0.2
                                        scale[i] = i == number ? 1.25 : 0.75
                                        
                                        if i == number {
                                            animationAmounts[i] += 360.0
                                        }
                                    }
                                }
                                
                                canTap = false
                            }
                        } label: {
                            FlagImage(
                                country: countries[number],
                                description: labels[countries[number], default: "Unknown Flag"]
                            )
                            .rotation3DEffect(
                                .degrees(animationAmounts[number]),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .scaleEffect(scale[number])
                            .opacity(opacity[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game Ended", isPresented: $showingGameEnded) {
            Button("Play Again", action: reset)
        } message: {
            Text("You scored \(score) out of 8!")
        }
    }
    
    func flagTapped(_ number: Int) {
        questionsAnswered += 1
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong - that is the flag of \(countries[number])"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            showingScore = true
        }
    }
    
    func askQuestion() {
        if (questionsAnswered == 8) {
            showingGameEnded = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
        
        canTap = true
        opacity = [1.0, 1.0, 1.0]
        scale = [1.0, 1.0, 1.0]
        animationAmounts = [0.0, 0.0, 0.0]
    }
    
    func reset() {
        questionsAnswered = 0
        score = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
