//
//  BookDetailView.swift
//  Bookworm
//
//  Created by Anthony Bath on 5/22/23.
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre ?? "Fantasy")
                    .resizable()
                    .scaledToFit()
                
                Text(book.genre?.uppercased() ?? "FANTASY")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }
            
            Text(book.author ?? "Unknown Author")
                .font(.title)
                .foregroundColor(.secondary)
            
            if let review = book.review {
                Text(review.isEmpty ? "No Review" : review)
                    .padding()
            } else {
                Text("No Review")
                    .padding()
            }
            
            Text("Book Added On: \(book.dateAdded!.formatted(.dateTime.day().month().year()))")
                .padding()
            
            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(book.title ?? "Unknown Title")
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingDeleteAlert = true
                } label: {
                    Label("Delete this book", systemImage: "trash")
                }
            }
        }
        .alert("Delete book?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure?")
        }
    }
    
    func deleteBook() {
        moc.delete(book)
        
#if targetEnvironment(simulator)
        // do nothing
#else
        try? moc.save()
#endif
        
        dismiss()
    }
}
