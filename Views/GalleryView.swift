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
                ForEach(viewModel.photos, id: \.id) { photo in
                    Text(photo.title)
                        .onAppear {
                            if self.viewModel.photos.last == photo && !viewModel.isFetching {
                                viewModel.loadAdditionalPhotos(query: "Yorkshire")
                            }
                        }
                    
                }
            }
        }
        .onAppear {
            viewModel.loadInitialPhotos(query: "Yorkshire")
        }
    }
}

#Preview {
    GalleryView()
}
