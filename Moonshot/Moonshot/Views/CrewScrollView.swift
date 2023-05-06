//
//  CrewScrollView.swift
//  Moonshot
//
//  Created by Anthony Bath on 5/6/23.
//

import SwiftUI

struct CrewScrollView: View {
    let crew: [CrewMember]
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.role) { member in
                    NavigationLink(value: member) {
                        HStack {
                            Image(member.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .strokeBorder(.white, lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(member.astronaut.name)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                
                                Text(member.role)
                                    .foregroundColor(.secondary)
                                
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct CrewScrollView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        CrewScrollView(mission: missions[0], astronauts: astronauts)
    }
}
