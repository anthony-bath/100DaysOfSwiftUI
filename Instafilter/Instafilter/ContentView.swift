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
    var body: some View {
        Text("Hello World")
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
