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
    @State private var qrCode = UIImage()
    
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
                
                Section("Your QR Code") {
                    HStack {
                        Spacer()
                        
                        Image(uiImage: qrCode)
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .contextMenu {
                                Button {
                                    ImageSaver().writeToPhotoAlbum(image: qrCode)
                                } label: {
                                    Label("Save to Photos", systemImage: "square.and.arrow.down")
                                }
                            }
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Me")
            .onAppear(perform: updateCode)
            .onChange(of: name) { _ in updateCode() }
            .onChange(of: email) { _ in updateCode() }
        }
    }
    
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(email)")
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
