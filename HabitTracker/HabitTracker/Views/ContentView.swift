//
//  ContentView.swift
//  HabitTracker
//
//  Created by Anthony Bath on 5/11/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var activities = Activities()
    @State private var showingAddView = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(activities.list) { activity in
                    NavigationLink(value: activity) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(activity.name)
                                    .font(.headline)
                                Text(activity.description)
                                    .font(.caption)
                            }
                            
                            Spacer()
                            
                            Text(activity.count, format: .number)
                        }
                    }
                }
            }
            .navigationDestination(for: Activity.self) { activity in
                ActivityDetailView(activity: activity) { updatedActivity in
                    trackActivity(updatedActivity)
                }
            }
            .navigationTitle("Habit Tracker")
            .toolbar {
                Button {
                    showingAddView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddActivityView(activities: activities)
            }
        }
    }
    
    func trackActivity(_ activity: Activity) {
        if let activityIndex = activities.list.firstIndex(where: { $0.id == activity.id }) {
            activities.list[activityIndex] = activity
        } else {
            print("Not found")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
