//
//  MissionView.swift
//  Moonshot
//
//  Created by Anthony Bath on 5/5/23.
//

import SwiftUI

struct MissionView: View {    
    let mission: Mission
    let astronauts: [String: Astronaut]
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image(decorative: mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geo.size.width*0.6)
                        .padding([.top, .bottom])
                    
                    VStack {
                        Text("Launch Date")
                            .font(.title3.bold())
                            .padding(.bottom,2)
                        
                        Text(mission.formattedLaunchDate)
                            .font(.title2.bold())
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Launch Date: \(mission.formattedLaunchDate)")
                    
                    VStack(alignment: .leading) {
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.lightBackground)
                            .padding(.vertical)
                        
                        Text("Mission Highlights")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                            .accessibilityAddTraits(.isHeader)
                        
                        Text(mission.description)
                        
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.lightBackground)
                            .padding(.vertical)
                        
                        Text("Crew")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                            .accessibilityAddTraits(.isHeader)
                    }
                    .padding(.horizontal)
                    
                    CrewScrollView(mission: mission, astronauts: astronauts)
                }
                .padding(.bottom)
            }
            .navigationTitle(mission.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: CrewMember.self) { member in
                AstronautView(astronaut: member.astronaut)
            }
            .background(.darkBackground)
        }
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        NavigationStack {
            MissionView(mission: missions[0], astronauts: astronauts)
        }
        .preferredColorScheme(.dark)
    }
}
