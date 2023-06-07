//
//  ContentView.swift
//  Instafilter
//
//  Created by Anthony Bath on 6/3/23.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var selectedImage: PhotosPickerItem?
    @State private var showingPhotosPicker = false
    @State private var currentFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    
                    Text("Tap to Select a Picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture { showingPhotosPicker = true }
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                }
                .padding(.vertical)
                .onChange(of: filterIntensity) { _ in applyProcessing() }
                
                HStack {
                    Button("Change Filter") { }

                    Spacer()

                    Button("Save", action: save)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .photosPicker(isPresented: $showingPhotosPicker, selection: $selectedImage)
            .onChange(of: selectedImage) { selection in
                guard let selection = selection else { return }
                
                Task {
                    do {
                        if let data = try await selection.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                let beginImage = CIImage(image: uiImage)
                                currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
                                applyProcessing()
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func applyProcessing() {
        currentFilter.intensity = Float(filterIntensity)
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            self.image = Image(uiImage: uiImage)
        }
    }
    
    func save() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/* Demo Code
 
 func loadImage() {
 guard let inputImage = inputImage else { return }
 image = Image(uiImage: inputImage)
 }
 
 func loadImageOld() {
 guard let inputImage = UIImage(named: "Example") else { return }
 let beginImage = CIImage(image: inputImage)
 
 let context = CIContext()
 let currentFilter = CIFilter.sepiaTone()
 
 currentFilter.inputImage = beginImage
 
 let amount = 1.0
 let inputKeys = currentFilter.inputKeys
 
 if inputKeys.contains(kCIInputIntensityKey) {
 currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
 }
 
 if inputKeys.contains(kCIInputRadiusKey) {
 currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey)
 }
 
 if inputKeys.contains(kCIInputScaleKey) {
 currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
 }
 
 guard let outputImage = currentFilter.outputImage else { return }
 
 if let cgImg = context.createCGImage(outputImage, from: outputImage.extent) {
 let uiImg = UIImage(cgImage: cgImg)
 image = Image(uiImage: uiImg)
 }
 }
 */
