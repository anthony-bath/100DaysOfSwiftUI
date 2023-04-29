//
//  PracticeView.swift
//  MultiplicationTables
//
//  Created by Anthony Bath on 4/27/23.
//

import SwiftUI

struct QuestionView: View {
    let question: Question
    let onSubmit: () -> Void
    
    @Binding var answer: String
    
    @FocusState private var answerFocused: Bool
    
    var body: some View {
        VStack(spacing: 25){
            ZStack {
                Color(red: 0.5, green: 0.87, blue: 0.23)
                    .frame(width: 300, height: 175)
                    .cornerRadius(25)
                    .shadow(color: Color.gray, radius: 5, x: 5, y: 5)
                
                Text(question.text)
                    .font(.system(size: 60))
            }
            
            
            ZStack {
                Color(red: 0.5, green: 0.54, blue: 63)
                    .frame(width: 300, height: 175)
                    .cornerRadius(25)
                    .shadow(color: Color.gray, radius: 5, x: 5, y: 5)
                
                HStack {
                    TextField("?", text: $answer)
                        .background(Color(red: 0.5, green: 0.54, blue: 63))
                        .frame(width: 150, height: nil)
                        .padding(.all, 5)
                        .font(Font.system(size: 60, design: .default))
                        .multilineTextAlignment(.center)
                        .cornerRadius(25)
                        .keyboardType(.numberPad)
                        .focused($answerFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                
                                Button("Answer") {
                                    answerFocused = false
                                    onSubmit()
                                }
                            }
                        }
                }
            }
        }
    }
}

struct PracticeView: View {
    let configuration: PracticeConfiguration
    let onFinish: () -> Void
    
    @State private var currentQuestion = 0
    @State private var answer = ""
    
    @State private var score = 0
    @State private var scoreTitle = ""
    @State private var scoreShown = false
    
    @State private var roundEndedShown = false
    
    var body: some View {
        VStack {
            QuestionView(
                question: configuration.questions[currentQuestion],
                onSubmit: onSubmit,
                answer: $answer
            )
        }
        .navigationTitle("\(configuration.table) Times Table")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("\(currentQuestion+1)/\(configuration.questions.count)")
            }
        }
        .alert(scoreTitle, isPresented: $scoreShown) {
            Button("Continue", action: onContinue)
        } message: {
            Text("Your score is \(score)/\(currentQuestion+1)")
        }
        .alert("Round Over!", isPresented: $roundEndedShown) {
            Button("Continue", action: onFinish)
        } message: {
            Text("""
                You got \(score) out of \(configuration.questions.count) - nice job!
                Try another round soon!
            """)
        }
    }
    
    func onSubmit() {
        let submittedAnswer: Int = Int(answer) ?? 0
        let correctAnswer = configuration.questions[currentQuestion].answer
        
        if submittedAnswer == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong - correct was \(correctAnswer)"
        }
        
        scoreShown = true
    }
    
    func onContinue() {
        scoreShown = false
        answer = ""
        
        if (currentQuestion == configuration.questions.count - 1) {
            roundEndedShown = true
        } else {
            currentQuestion += 1
        }
    }
}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PracticeView(
                configuration: PracticeConfiguration.sample,
                onFinish: { }
            )
        }
    }
}
