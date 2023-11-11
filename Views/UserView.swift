//
//  UserGalleryView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import SwiftUI

struct UserView: View {
    @StateObject var viewModel = UserViewModel()
    @State private var visibleItems: Set<UUID> = []
    
    var user: User
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            if user.profileInfo.city != nil && user.profileInfo.city != "" {
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                        .foregroundColor(.gray) // Set the color to gray
                                        .font(.footnote)
                                    Text(user.profileInfo.city!)
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                }
                            }
                            
                            Text(user.userInfo.username._content)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.vertical, 4)
                            
                            HStack {
                                HStack() {
                                    Text(String(user.userInfo.photos?.count._content ?? 0))
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
                        
                        UserProfileImageView(url: user.buddyIconURL)
                            .frame(width: 64, height: 64)
                    }
                    .padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        if user.profileInfo.description?._content != nil {
                            Text(user.profileInfo.description!._content)
                                .font(.footnote)
                                .opacity(0.8)
                        }
                    }
                }
                .padding()
                
                if user.profileInfo.description?._content != nil {
                    Text(user.profileInfo.description!._content)
                        .font(.footnote)
                        .opacity(0.8)
                }
                
                if viewModel.userGalleries.count > 0 {
                    Text("Galleries")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.userGalleries, id: \.galleryId) { gallery in
                                NavigationLink(destination: GalleryView(gallery: gallery, user: user)) {
                                    VStack(alignment: .leading) {
                                        RemoteGalleryImageView(title: gallery.title._content, url: viewModel.getGalleryThumbnail(gallery: gallery)!)
                                    }
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
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                
                Text("Photos")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                
                ForEach(viewModel.userPhotoItems, id: \.id) { userPhoto in
                    NavigationLink(destination: PhotoDetailView(photo: userPhoto)) {
                        VStack {
                            RemoteImageView(url: viewModel.getPhotoUrl(photo: userPhoto.photo)!)
                        }
                        .padding(.horizontal)
                        .opacity(visibleItems.contains(userPhoto.id) ? 1 : 0)
                        .onAppear {
                            withAnimation(.easeIn(duration: 0.5)) {
                                visibleItems.insert(userPhoto.id)
                            }
                            
                            // load more only if more than one item and near the end of the list
                            if viewModel.userPhotoItems.count > 1,
                               let index = viewModel.userPhotoItems.firstIndex(where: {$0.id == userPhoto.id}),
                               index >= viewModel.userPhotoItems.count - 3,
                               !viewModel.isFetching {
                                viewModel.loadAdditionalUserPhotoItems(user: userPhoto.user)
                            }
                        }
                    }
                    
                }
                
                
            }
            
        }
        .onAppear {
            Task {
                await viewModel.fetchDataIfNeeded(user: user, page: 1)
            }
        }
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    UserView(user: User(userInfo: MiniFlickr.UserInfo(id: "42317772@N04", nsid: "42317772@N04", username: MiniFlickr.NestedStringContentWrapper(_content: "Rainbowfish7"), iconServer: Optional("65535"), iconFarm: 66), profileInfo: MiniFlickr.ProfileInfo(occupation: Optional(""), description: nil, city: "", firstName: "Daniel", lastName: "Priestley")))
//}
