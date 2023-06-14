//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Anthony Bath on 6/14/23.
//

import Foundation

extension EditView {
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @MainActor class ViewModel: ObservableObject {
        @Published var name: String
        @Published var description: String
        @Published var loadingState = LoadingState.loading
        @Published var pages = [Page]()
        private(set) var location: Location
        
        init(location: Location) {
            self.location = location
            self.name = location.name
            self.description = location.description
        }
        
        func getUpdatedLocation() -> Location {
            var updatedLocation = location
            
            updatedLocation.id = UUID()
            updatedLocation.name = self.name
            updatedLocation.description = self.description
            
            return updatedLocation
        }
    }
}
