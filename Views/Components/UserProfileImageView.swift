//
//  UserProfileImageView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 10/11/2023.
//

import SwiftUI

struct UserProfileImageView: View {
    @State private var image: Image?
    @State private var isLoading = false
    
    let url: URL?
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            } else if isLoading {
                ProgressView()
                    .frame(width: 28, height: 28)
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 28, height: 28)
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let url = url else {
            return
        }
        
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
                throw NetworkError.failedToFetchRemoteImage
            }
        }
    }
}
