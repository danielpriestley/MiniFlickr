//
//  RemoteGalleryImageView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 09/11/2023.
//

import SwiftUI

struct RemoteGalleryImageView: View {
    @State private var image: Image?
    @State private var isLoading = false
    
    let title: String
    let url: URL
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140)
                    .clipped()
                    .overlay(
                        alignment: .bottomLeading,
                        content: {
                            HStack {
                                Text(title)
                                    .font(.caption)
                                    .padding(8)
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                            )
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
            } else if isLoading {
                VStack {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // make centered
                        .padding()
                }
                .frame(width: 200, height: 200)
            } else {
                Color.gray
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
                throw NetworkError.failedToFetchRemoteImage
            }
        }
    }
}

//#Preview {
//    RemoteImageView()
//}
