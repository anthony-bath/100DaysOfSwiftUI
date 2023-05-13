//
//  ActivityDetailView.swift
//  HabitTracker
//
//  Created by Anthony Bath on 5/13/23.
//

import SwiftUI

struct ActivityDetailView: View {
    var activity: Activity
    
    var body: some View {
        VStack {
            Text(activity.name)
            Text(activity.description)
        }
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView(activity: Activity.example)
    }
}
