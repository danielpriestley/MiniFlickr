//
//  GalleryView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import SwiftUI

struct GalleryView: View {
    @StateObject private var viewModel = GalleryViewModel()
    @State private var isLoadingContent = true
    @State private var searchQuery = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    if isLoadingContent {
                        ProgressView()
                            .scaleEffect(1.5)
                    } else {
                        ForEach(viewModel.userPhotoItems, id: \.id) { item in
                            VStack {
                                NavigationLink(destination: UserView(user: item.user)) {
                                    HStack {
                                        AsyncImage(url: item.userPhotoURL)
                                            .frame(width: 28, height: 28)
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .padding(.trailing, 4)
                                        Text(item.username)
                                            .font(.footnote)
                                            .bold()
                                        Spacer()
                                    }
                                    .padding(.bottom, 4)
                                }
                                .buttonStyle(PlainButtonStyle())
                                NavigationLink(destination: PhotoDetailView(photo: item)){
                                    RemoteImageView(url: viewModel.getPhotoUrl(photo: item.photo)!)
                                }
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(viewModel.getTagsFromPhoto(photo: item.photo, tagAmount: 16), id: \.self) { tag in
                                            Text(tag)
                                                .font(.caption)
                                                .padding(4)
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(4)
                                        }
                                    }
                                }
                                
                                .padding(.bottom)
                                
                            }
                            .padding()
                            .onAppear {
                                if let index = self.viewModel.userPhotoItems.firstIndex(where: {$0.id == item.id}) {
                                    if index == self.viewModel.userPhotoItems.count - 3 && !viewModel.isFetching {
                                        viewModel.loadAdditionalPhotoItems(query: !searchQuery.isEmpty ? searchQuery : "yorkshire")
                                    }
                                }
                            }
                            
                        }
                    }
                    
                    if viewModel.isFetching {
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                    
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadInitialPhotoItems(query: "Yorkshire")
                    isLoadingContent = false
                }
            }
            .navigationTitle("Gallery")
        }
        .searchable(text: $searchQuery)
        .onSubmit(of: .search, {
            viewModel.userPhotoItems = []
            isLoadingContent = true
            Task {
                await viewModel.loadInitialPhotoItems(query: searchQuery)
                isLoadingContent = false
            }
        })
        
    }
}



#Preview {
    GalleryView()
}
