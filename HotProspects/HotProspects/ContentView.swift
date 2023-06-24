//
//  ContentView.swift
//  HotProspects
//
//  Created by Anthony Bath on 6/22/23.
//

import SwiftUI
import UserNotifications
import SamplePackage

@MainActor class DelayedUpdater: ObservableObject {
    var value = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var updater = DelayedUpdater()
    @State private var output = ""
    @State private var backgroundColor = Color.red

    
    var body: some View {
        Text("Hello World")
//        VStack {
//            Text("Hello World")
//                .padding()
//                .background(backgroundColor)
//
//            Text("Change Color")
//                .contextMenu {
//                    Button("Red") { backgroundColor = .red}
//                    Button("Green") { backgroundColor = .green }
//                    Button("Blue") {  backgroundColor = .blue }
//                }
//            Button("Request Permission") {
//                UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { success, error in
//                    if success {
//                        print("All set!")
//                    } else if let error = error {
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//
//            Button("Schedule Notification") {
//                let content = UNMutableNotificationContent()
//                content.title = "Feed the Dogs"
//                content.subtitle = "They look hungry"
//                content.sound = UNNotificationSound.default
//
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//                UNUserNotificationCenter.current().add(request)
//            }
//        }
        
    }
    
    func fetchReadings() async {
        let fetchTask = Task { () -> String in
            let url = URL(string: "https://hws.dev/readings.json")!
            let (data,_) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            
            return "Found \(readings.count) Readings"
        }
        
        let result = await fetchTask.result
        
        switch result {
        case .success(let str):
            output = str
        case .failure(_):
            output = "Download Failed"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
