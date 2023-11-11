//
//  RemoteImageView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 04/11/2023.
//

import SwiftUI

struct RemoteImageView: View {
    @State private var image: Image?
    @State private var isLoading = false
    
    let url: URL
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
            } else if isLoading {
                VStack {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // make centered
                        .padding()
                }
                .frame(width: 200, height: 200)
            } else {
                Color.gray // temp placeholder TODO: Fix this
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        isLoading = true
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    image = Image(uiImage: uiImage)
                }
                isLoading = false
            } catch {
                isLoading = false
                print("Image loading error: \(error)")
            }
        }
    }
}

//#Preview {
//    RemoteImageView()
//}
