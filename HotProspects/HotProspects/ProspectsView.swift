//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Anthony Bath on 6/24/23.
//

import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    enum SortType {
        case name, email, dateAdded
    }
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var isShowingSortDialog = false
    @State private var sortType: SortType = .name
    
    let filter: FilterType
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredSortedProspects) { prospect in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            
                            Text(prospect.email)
                                .foregroundColor(.secondary)
                        }
                        
                        if filter == .none && prospect.isContacted {
                            Spacer()
                            
                            Image(systemName: "checkmark.message.fill")
                                .foregroundColor(.green)
                                .padding(.trailing,5)
                        }
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Un-contacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind Me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingSortDialog = true
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down.square")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(
                    codeTypes: [.qr],
                    simulatedData: "Tom Hall\ntom@hackingwithswift.com",
                    completion: handleScan
                )
            }
            .confirmationDialog("Sort By", isPresented: $isShowingSortDialog, titleVisibility: .visible) {
                Button("Name") {
                    sortType = .name
                    isShowingSortDialog = false
                }
                
                Button("E-mail") {
                    sortType = .email
                    isShowingSortDialog = false
                }
                
                Button("Date Added") {
                    sortType = .dateAdded
                    isShowingSortDialog = false
                }
            }

        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
            
        case .contacted:
            return "Contacted People"
            
        case .uncontacted:
            return "Un-contacted People"
        }
    }
    
    var filteredSortedProspects: [Prospect] {
        var filtered: [Prospect]
        
        switch filter {
        case .none:
            filtered = prospects.people
        case .contacted:
            filtered = prospects.people.filter { $0.isContacted }
        case .uncontacted:
            filtered = prospects.people.filter { !$0.isContacted }
        }
        
        switch sortType {
        case .name:
            return filtered.sorted { $0.name < $1.name }
        case .email:
            return filtered.sorted { $0.email < $1.email }
        case .dateAdded:
            return filtered.sorted { $0.dateAdded > $1.dateAdded }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let success):
            let details = success.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            prospects.add(Prospect(name: details[0], email: details[1]))
        case .failure(let failure):
            print("Scanning Failed: \(failure.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.email
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents(hour: 9)
            
            #if targetEnvironment(simulator)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            #else
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            #endif

            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger
            )
            
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Cannot schedule notification")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
