//
//  ContentView.swift
//  RockPaperScissorsBrainTraining
//
//  Created by Anthony Bath on 4/19/23.
//

import SwiftUI

struct ImageButton: View {
    var imageName: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "\(imageName)")
                .resizable()
                .scaledToFit()
                .frame(width: 85, height: 85)
                .foregroundColor(.white)
        }
        .frame(width: 200, height: 125)
        .background(Color(red: 0.4, green: 0.2, blue: 0.6))
        .clipShape(Capsule())
    }
}

struct ContentView: View {
    
    @State private var choices = ["Rock", "Paper", "Scissors"]
    
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
                
                ImageButton(imageName: "mountain.2", action: onSelectAnswer(type: "Rock"))
                ImageButton(imageName: "doc", action: onSelectAnswer(type: "Paper"))
                ImageButton(imageName: "scissors", action: onSelectAnswer(type: "Scissors"))
                
                Spacer()
            }
        }
    }
    
    func onSelectAnswer(type: String) -> () -> Void {
        func action() { }
        
        return action
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
