//
//  GalleryView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 09/11/2023.
//

import SwiftUI

struct GalleryView: View {
    @StateObject var viewModel = GalleryViewModel()
    @State private var visibleItems: Set<String> = []

    var gallery: Gallery
    var user: User
    
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                if gallery.description._content != "" {
                    Text("Description")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                    Text(gallery.description._content)
                        .font(.footnote)
                        .padding(.bottom)
                }
                
                ForEach(viewModel.galleryPhotos, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                        NavigationLink(destination: PhotoDetailView(photo: item)) {
                            RemoteImageView(url: viewModel.getPhotoUrl(photo: item)!)
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.getTagsFromPhoto(photo: item, tagAmount: 16), id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption)
                                        .padding(4)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(4)
                                }
                            }
                        }
                        
                    }
                    .padding(.bottom)
                    .opacity(visibleItems.contains(item.id) ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.5)) {
                            visibleItems.insert(item.id)
                        }
                        
                        if let index = self.viewModel.galleryPhotos.firstIndex(where: {$0.id == item.id}) {
                            if index == self.viewModel.galleryPhotos.count - 3 && !viewModel.isFetching {
                                viewModel.loadAdditionalGalleryPhotos(galleryId: gallery.galleryId, userId: user.userInfo.id)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            Task {
                await viewModel.getGalleryPhotos(userId: user.userInfo.id, galleryId: gallery.galleryId)
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle(gallery.title._content)
        .navigationBarTitleDisplayMode(.large)
    }
}
