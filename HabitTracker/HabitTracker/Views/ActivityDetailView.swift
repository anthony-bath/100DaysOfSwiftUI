//
//  ActivityDetailView.swift
//  HabitTracker
//
//  Created by Anthony Bath on 5/13/23.
//

import SwiftUI

struct ActivityDetailView: View {
    var activity: Activity
    var onTrackActivity: (Activity) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text(activity.description)
                .padding(.bottom, 35)
                .padding(.horizontal)
            
            VStack {
                HStack {
                    Spacer()
                    Text("Streak: \(activity.count)")
                        .font(.system(size: 35))
                    Spacer()
                }
                .padding(.bottom, 35)
            }
            
            Button {
                var updatedActivity = activity
                updatedActivity.count += 1
                onTrackActivity(updatedActivity)
                dismiss()
            } label: {
                Label("Track!", systemImage: "pencil")
                    .font(.system(size: 25))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle(activity.name)
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ActivityDetailView(activity: Activity.example) { updatedActivity in
                
            }
        }
    }
}
