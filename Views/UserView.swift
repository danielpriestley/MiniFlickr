//
//  UserGalleryView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import SwiftUI

struct UserView: View {
    @StateObject var viewModel = UserViewModel()
    var user: User
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
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
                        
                        AsyncImage(url: user.buddyIconURL) { image in
                            image.image?.resizable()
                        }
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
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
                            ForEach(viewModel.userGalleries, id: \.id) { gallery in
                                RemoteImageView(url: viewModel.getGalleryThumbnail(gallery: gallery)!)
                                    .frame(width: 140)
                                
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
                
                
                Text("Photos")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                
                ForEach(viewModel.userPhotos, id: \.id) { userPhoto in
                    NavigationLink(destination: PhotoDetailView(photo: userPhoto)) {
                        VStack {
                            RemoteImageView(url: viewModel.getPhotoUrl(photo: userPhoto.photo)!)
                        }
                        .padding(.horizontal)
                        
                    }
                }
                
            }
            
            
        }
        .onAppear {
            Task {
                await viewModel.getUserPhotos(user: user)
                await viewModel.getUserGalleries(userId: user.userInfo.nsid)
            }
        }
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    
    
}

#Preview {
    UserView(user: User(userInfo: MiniFlickr.UserInfo(id: "42317772@N04", nsid: "42317772@N04", username: MiniFlickr.NestedStringContentWrapper(_content: "Rainbowfish7"), iconServer: Optional("65535"), iconFarm: 66), profileInfo: MiniFlickr.ProfileInfo(occupation: Optional(""), description: nil, city: "", firstName: "Daniel", lastName: "Priestley")))
}
