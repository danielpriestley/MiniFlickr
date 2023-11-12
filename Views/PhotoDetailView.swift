//
//  ImageDetailView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import SwiftUI

struct PhotoDetailView: View {
    @StateObject private var viewModel = PhotoDetailViewModel()
    
    var photo: Photo
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(destination: UserView(userId: photo.owner, profileImageUrl: photo.profileImageUrl)) {
                        UserProfileImageView(url: photo.profileImageUrl)
                            .frame(width: 28, height: 28)
                            .padding(.trailing, 4)
                        Text(photo.ownername)
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
                
                Text(photo.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                if isHTML(photo.descriptionContent) {
                    HTMLTextView(htmlString: photo.descriptionContent, font: UIFont.systemFont(ofSize: 14, weight: .semibold), textColor: .gray)
                        .frame(height: 80)
                } else {
                    Text(photo.descriptionContent)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                }
                
                
                RemoteImageView(url: viewModel.getPhotoUrl(photo: photo)!)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.getTagsFromPhoto(photo: photo, tagAmount: 16), id: \.self) { tag in
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
                    NavigationLink(destination: UserView(userId: photo.owner, profileImageUrl: photo.profileImageUrl)) {
                        Text(photo.ownername)
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
                            NavigationLink(destination: PhotoDetailView(photo: userPhoto)) {
                                RemoteImageView(url: viewModel.getPhotoUrl(photo: userPhoto)!)
                                
                            }
                        }
                        .frame(height: 120)
                    }
                    
                    Spacer()
    
                }
            }
            .padding()
            .onAppear {
                Task {
                    await viewModel.getMorePhotosFromUser(userId: photo.owner, currentPhotoId: photo.id)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .scrollIndicators(.hidden)
        }
    }
}

