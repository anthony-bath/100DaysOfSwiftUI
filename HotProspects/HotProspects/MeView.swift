//
//  MeView.swift
//  HotProspects
//
//  Created by Anthony Bath on 6/24/23.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct MeView: View {
    @State private var name = "Anonymous"
    @State private var email = "you@yoursite.com"
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                
                TextField("E-Mail", text: $email)
                    .textContentType(.emailAddress)
                    .font(.title)
                
                Section {
                    Image(uiImage: generateQRCode(from: "\(name)\n\(email)"))
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
            }
            .navigationTitle("Me")
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
