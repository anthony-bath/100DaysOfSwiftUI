//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Anthony Bath on 7/1/23.
//

import SwiftUI

extension VerticalAlignment {
    struct MidAccountAndName: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.top]
        }
    }
    
    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}

struct ContentView: View {
    var body: some View {
        HStack(alignment: .midAccountAndName) {
            VStack {
                Text("@twostraws")
                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
                Image("beach")
                    .resizable()
                    .frame(width: 64, height: 64)
            }
            
            VStack {
                Text("Full Name:")
                Text("Paul Hudson")
                    .font(.largeTitle)
                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
