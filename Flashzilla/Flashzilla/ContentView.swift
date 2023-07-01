//
//  ContentView.swift
//  Flashzilla
//
//  Created by Anthony Bath on 6/26/23.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset*10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    
    @State private var cards = [Card]()
    @State private var timeRemaining = 100
    @State private var isActive = true
    @State private var showingEditView = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
                .accessibilityHidden(true)
            
            VStack {
                Text("Time Remaining: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .padding()
                
                ZStack {
                    ForEach(cards) { card in
                        CardView(card: card) { result in
                            if result {
                                withAnimation { removeCard(card: card) }
                            } else {
                                withAnimation { replaceCardAtEnd(card: card) }
                            }
                        }
                        .stacked(at: cards.firstIndex(of: card) ?? 0, in: cards.count)
                        .allowsHitTesting(cards.firstIndex(of: card) ?? 0 == cards.count - 1)
                        .accessibilityHidden(cards.firstIndex(of: card) ?? 0 < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingEditView = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation { replaceCardAtEnd(card: cards[cards.count - 1])  }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")
                        
                        Spacer()
                        
                        Button {
                            withAnimation { removeCard(card: cards[cards.count - 1]) }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { _ in
            guard isActive else { return }

            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active && !cards.isEmpty {
                isActive = true
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditView, onDismiss: resetCards, content: EditCardsView.init)
        .onAppear(perform: resetCards)
    }
    
    func removeCard(card: Card) {
        cards.removeAll { $0 == card }
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func replaceCardAtEnd(card: Card) {
        cards.removeAll { $0 == card }
        let newCard = Card(prompt: card.prompt, answer: card.answer)
        cards.insert(newCard, at: 0)
    }
    
    func resetCards() {
        cards = CardsIO.load()
        timeRemaining = 100
        isActive = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
