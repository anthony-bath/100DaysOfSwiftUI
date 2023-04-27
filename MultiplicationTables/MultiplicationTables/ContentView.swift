//
//  ContentView.swift
//  MultiplicationTables
//
//  Created by Anthony Bath on 4/27/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTable = 2
    @State private var selectedQuestionCount = 5
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            Form {
                VStack(alignment: .leading) {
                    Text("What table shall we practice?")
                        .font(.headline)
                        .padding(.bottom,10)
                    
                    Stepper("\(selectedTable) times table", value: $selectedTable, in: 2...12)
                }
                
                VStack(alignment: .leading) {
                    Text("How many questions?")
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    Picker("From Units", selection: $selectedQuestionCount) {
                        ForEach([5,10,15], id: \.self) {
                            Text($0, format: .number)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                
                Button("Start") {
                    path.append(getConfiguration())
                }
                
            }
            .navigationTitle("Practice Time Tables")
            .navigationDestination(for: PracticeConfiguration.self) { configuration in
                PracticeView(
                    configuration: configuration,
                    onFinish: {
                        path.removeLast(1)
                    }
                )
            }
            
        }
    }
    
    func getConfiguration() -> PracticeConfiguration {
        PracticeConfiguration(
            table: selectedTable,
            questions: generateQuestions()
        )
    }
    
    func generateQuestions() -> [Question] {
        var questions = [Question]()
        
        for _ in 0..<selectedQuestionCount {
            questions.append(Question(left: selectedTable, right: Int.random(in: 2...12)))
        }
        
        return questions
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
