//
//  ImagePicker.swift
//  Instafilter
//
//  Created by Anthony Bath on 6/5/23.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
}
