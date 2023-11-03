//
//  GalleryView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import SwiftUI

struct GalleryView: View {
    @StateObject private var viewModel = GalleryViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack { // LazyVStack to increase performance
                ForEach(viewModel.userPhotoItems, id: \.id) { item in
                    Text(item.username)
                    Text(item.photoTitle)
                    Text(item.photo.server)
                    Text("\(item.photo.farm)")
                    AsyncImage(url: URL(string: "https://live.staticflickr.com/\(item.photo.server)/\(item.photo.id)_\(item.photo.secret).jpg"))
                        .onAppear {
                            if self.viewModel.userPhotoItems.last == item && !viewModel.isFetching {
                                viewModel.loadAdditionalPhotos(query: "Yorkshire")
                            }
                        }
                }
            }
        }
        .onAppear {
            viewModel.loadInitialPhotoItems(query: "Yorkshire")
        }
    }
}

#Preview {
    GalleryView()
}
