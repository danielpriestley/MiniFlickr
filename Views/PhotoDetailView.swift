//
//  ImageDetailView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import SwiftUI

struct PhotoDetailView: View {
    @StateObject private var viewModel = PhotoDetailViewModel()
    
    var photo: UserPhotoItem
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    NavigationLink(destination: UserView(user: photo.user)) {
                        AsyncImage(url: photo.userPhotoURL)
                            .frame(width: 28, height: 28)
                            .scaledToFill()
                            .clipShape(Circle())
                            .padding(.trailing, 4)
                        Text(photo.username)
                            .font(.footnote)
                            .bold()
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Text(photo.uploadDate)
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                }
                .padding(.bottom, 4)
                HStack {
                    Text(photo.photoTitle)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                }
                HStack {
                    Text(photo.photo.descriptionContent)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                RemoteImageView(url: viewModel.getPhotoUrl(photo: photo.photo)!)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.getTagsFromPhoto(photo: photo.photo, tagAmount: 16), id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(4)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                }
                .padding(.bottom, 16)
                    
                HStack(alignment: .bottom) {
                    Text("More photos from")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                        .padding(.trailing, -4)
                    NavigationLink(destination: UserView(user: photo.user)) {
                        Text(photo.username)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                .padding(.top)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.userPhotos, id: \.id) { userPhoto in
                            NavigationLink(destination: PhotoDetailView(photo: UserPhotoItem(photo: userPhoto, user: photo.user))) {
                                RemoteImageView(url: viewModel.getPhotoUrl(photo: userPhoto)!)
                            }
                                
                            
                        }
                    }
                    .frame(height: 120)
                }
                
                
                Spacer()
                
                
            }
            .padding()
        }
        
        .onAppear {
            Task {
                await viewModel.getMorePhotosFromUser(userId: photo.user.userInfo.nsid)
                
                print(viewModel.userPhotos.count)
            }
            
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    PhotoDetailView(photo: UserPhotoItem(photo: MiniFlickr.Photo(id: "53312315478", owner: "50522809@N05", title: "Turn, Turn, Turn", secret: "5d678b1292", server: "65535", farm: 66, tags: "northyorkshire cityofyork york yorkshire autumn", description: {NestedContentWrapper(_content: "Some lovely trees around yorkshire")}(), license: "0", dateupload: "1699223481", ownername: "Feversham Media", iconserver: "65535"), user: MiniFlickr.User(userInfo: MiniFlickr.UserInfo(id: "50522809@N05", nsid: "50522809@N05", username: MiniFlickr.NestedContentWrapper(_content: "Feversham Media"), iconServer: Optional("65535"), iconFarm: 66), profileInfo: MiniFlickr.ProfileInfo(occupation: Optional(""), description: nil, city: Optional(""), firstName: Optional("Andrew"), lastName: Optional("Gallon")))))
}
