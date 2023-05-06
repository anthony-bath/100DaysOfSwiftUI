//
//  ListContentView.swift
//  Moonshot
//
//  Created by Anthony Bath on 5/6/23.
//

import SwiftUI

struct ListContentView: View {
    let missions: [Mission]
    
    var body: some View {
        List {
            ForEach(missions) { mission in
                NavigationLink(value: mission) {
                    HStack {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .padding(.trailing)
                        
                        VStack(alignment: .leading) {
                            Text(mission.displayName)
                                .font(.title2)
                                .foregroundColor(.white)
                            
                            Text(mission.formattedLaunchDate)
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.vertical)
                    }
                }
                .padding([.top,.bottom])
            }
            .listRowBackground(Color.darkBackground)
        }
        .listStyle(.plain)
        .preferredColorScheme(.dark)
    }
}

struct ListContentView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    
    static var previews: some View {
        ListContentView(missions: missions)
    }
}
