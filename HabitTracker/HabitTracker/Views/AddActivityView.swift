//
//  AddActivityView.swift
//  HabitTracker
//
//  Created by Anthony Bath on 5/11/23.
//

import SwiftUI

struct AddActivityView: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @ObservedObject var activities: Activities
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .keyboardType(.default)
                    
                    TextField("Description", text: $description)
                        .lineLimit(5)
                    
                } header: {
                    Text("Activity")
                }
            }
            .navigationTitle("New Activity")
            .toolbar {
                Button("Save") {
                    let activity = Activity(name: name, description: description)
                    activities.list.append(activity)
                    dismiss()
                }
            }
        }
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView(activities: Activities())
    }
}
