//
//  UserGalleryView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import SwiftUI

struct UserView: View {
    @StateObject var viewModel = UserViewModel()
    @State private var visibleItems: Set<String> = []
    
    
    var userId: String
    var profileImageUrl: URL
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            if viewModel.user?.profileInfo.city != nil && viewModel.user?.profileInfo.city != "" {
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                        .foregroundColor(.gray)
                                        .font(.footnote)
                                    Text(viewModel.user?.profileInfo.city ?? "")
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                }
                            }
                            
                            Text(viewModel.user?.userInfo.username._content ?? "")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.vertical, 4)
                            
                            HStack {
                                HStack() {
                                    Text(String(viewModel.user?.userInfo.photos?.count._content ?? 0))
                                        .fontWeight(.bold)
                                        .padding(.trailing, -4)
                                    Text("Photos")
                                        .foregroundStyle(.gray)
                                }
                                
                                HStack {
                                    Text(String(viewModel.userGalleries.count))
                                        .fontWeight(.bold)
                                        .padding(.trailing, -4)
                                    Text(viewModel.userGalleries.count == 1 ? "Gallery" : "Galleries")
                                        .foregroundStyle(.gray)
                                }
                            }
                            .font(.footnote)
                        }
                        
                        Spacer()
                        
                            UserProfileImageView(url: profileImageUrl)
                                .frame(width: 64, height: 64)
                                .redacted(reason: viewModel.user == nil ? .placeholder : [])
                       
                    }
                    .padding(.bottom)

                }
                .padding()
                
                
                if viewModel.userGalleries.count > 0 {
                    Text("Galleries")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            if let user = viewModel.user {
                                ForEach(viewModel.userGalleries, id: \.galleryId) { gallery in
                                    
                                    NavigationLink(destination: GalleryView(gallery: gallery, user: user)) {
                                        RemoteGalleryImageView(title: gallery.title._content, url: viewModel.getGalleryThumbnail(gallery: gallery)!)
                                    }
                                    
                                    .onAppear {
                                        // load more only if there's more than one item and user is near the end of the list
                                        if viewModel.userGalleries.count > 1,
                                           let index = viewModel.userGalleries.firstIndex(where: {$0.galleryId == gallery.galleryId}),
                                           index >= viewModel.userGalleries.count - 3,
                                           !viewModel.isFetching {
                                            viewModel.loadAdditionalGalleries(userId: user.userInfo.nsid)
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                
                Text("Photos")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                
                ForEach(viewModel.photos, id: \.id) { userPhoto in
                    NavigationLink(destination: PhotoDetailView(photo: userPhoto)) {
                        VStack {
                            RemoteImageView(url: viewModel.getPhotoUrl(photo: userPhoto)!)
                        }
                        .padding(.horizontal)
                        .opacity(visibleItems.contains(userPhoto.id) ? 1 : 0)
                        .onAppear {
                            withAnimation(.easeIn(duration: 0.5)) {
                                visibleItems.insert(userPhoto.id)
                            }
                            
                            // load more only if more than one item and near the end of the list
                            if viewModel.photos.count > 1,
                               let index = viewModel.photos.firstIndex(where: {$0.id == userPhoto.id}),
                               index >= viewModel.photos.count - 3,
                               !viewModel.isFetching {
                                viewModel.loadAdditionalPhotos(userId: userPhoto.owner)
                            }
                        }
                    }
                    
                }
                
                
            }
            
        }
        .onAppear {
            Task {
                await viewModel.fetchDataIfNeeded(userId: userId, page: 1)
            }
        }
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
    }
}
