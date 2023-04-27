//
//  PracticeView.swift
//  MultiplicationTables
//
//  Created by Anthony Bath on 4/27/23.
//

import SwiftUI

struct QuestionView: View {
    let question: Question
    
    @State private var answer = ""
    
    var body: some View {
        VStack(spacing: 25){
            ZStack {
                Color(red: 0.5, green: 0.87, blue: 0.23)
                    .frame(width: 300, height: 200)
                    .cornerRadius(25)
                    .shadow(color: Color.gray, radius: 5, x: 5, y: 5)
                
                Text(question.text)
                    .font(.system(size: 60))
            }
            
            
            ZStack {
                Color(red: 0.5, green: 0.54, blue: 63)
                    .frame(width: 300, height: 200)
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
                }
            }
        }
    }
}

struct PracticeView: View {
    let configuration: PracticeConfiguration
    let onFinish: () -> Void
    
    @State private var currentQuestion = 0
    
    var body: some View {
        VStack {
            QuestionView(question: configuration.questions[currentQuestion])
        }
        .navigationTitle("\(configuration.table) Times Table")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("\(currentQuestion+1)/\(configuration.questions.count)")
            }
        }
    }
    
    func onSubmit() {
        
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
