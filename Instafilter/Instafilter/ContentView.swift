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
    @State private var selectedUIImage: UIImage?
    @State private var processedUIImage: UIImage?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    @State private var selectedImage: PhotosPickerItem?
    @State private var showingPhotosPicker = false
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var showingFilterSheet = false
    
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
                
                if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                    HStack {
                        Text("Intensity")
                        Slider(value: $filterIntensity)
                    }
                    .padding(.vertical)
                    .onChange(of: filterIntensity) { _ in applyProcessing() }
                }
                
                if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                    HStack {
                        Text("Radius")
                        Slider(value: $filterRadius)
                    }
                    .padding(.vertical)
                    .onChange(of: filterRadius) { _ in applyProcessing() }
                }
                
                if currentFilter.inputKeys.contains(kCIInputScaleKey) {
                    HStack {
                        Text("Scale")
                        Slider(value: $filterScale)
                    }
                    .padding(.vertical)
                    .onChange(of: filterScale) { _ in applyProcessing() }
                }
                
                HStack {
                    Button("Change Filter") { showingFilterSheet = true }
                    Spacer()
                    Button("Save", action: save)
                        .disabled(image == nil)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .photosPicker(isPresented: $showingPhotosPicker, selection: $selectedImage)
            .confirmationDialog("Select Filter", isPresented: $showingFilterSheet) {
                Group {
                    Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                    Button("Edges") { setFilter(CIFilter.edges()) }
                    Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                    Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                    Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                    Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                    Button("Vignette") { setFilter(CIFilter.vignette()) }
                    Button("Thermal") { setFilter(CIFilter.thermal()) }
                    Button("X-Ray") { setFilter(CIFilter.xRay()) }
                    Button("Bump Distortion") { setFilter(CIFilter.bumpDistortion()) }
                }
                
                Button("Cancel", role: .cancel) { }
            }
            .onChange(of: selectedImage) { selection in
                guard let selection = selection else { return }
                
                Task {
                    do {
                        if let data = try await selection.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                selectedUIImage = uiImage
                                load()
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func load() {
        guard let selectedUIImage = selectedUIImage else { return }
        
        let beginImage = CIImage(image: selectedUIImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius * 1000, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale * 100, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            if let selectedUIImage = selectedUIImage {
                currentFilter.setValue(
                    CIVector(
                        x: selectedUIImage.size.width / 2,
                        y: selectedUIImage.size.height / 2
                    ),
                    forKey: kCIInputCenterKey
                )
            }
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            
            self.processedUIImage = uiImage
            self.image = Image(uiImage: uiImage)
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter;
        load();
    }
    
    func save() {
        guard let processedUIImage = processedUIImage else { return }
        
        let saver = ImageSaver()
        
        saver.successHandler = { print("Success") }
        saver.errorHandler = { print($0.localizedDescription)}
        saver.writeToPhotoAlbum(image: processedUIImage)
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
