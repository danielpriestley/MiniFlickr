//
//  GalleryView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import SwiftUI
import TipKit

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    
    @State private var path: [Int] = []
    @State private var isLoadingContent = true
    @State private var searchQuery = ""
    @State private var initialSearchPerformed = false
    @State private var isShowingBackToTopButton = false
    @State private var visibleItems: Set<UUID> = []
    
    var searchBarTip = SearchBarTip()
    
    var body: some View {
        NavigationStack {
            VStack {
                TipView(searchBarTip, arrowEdge: .top)
            }
            .padding(.horizontal)
            ScrollViewReader { scrollProxy in
                ScrollView{
                    LazyVStack {
                        if isLoadingContent {
                            ProgressView()
                        } else {
                            ForEach(viewModel.userPhotoItems, id: \.id) { item in
                                VStack {
                                    NavigationLink(destination: UserView(user: item.user)) {
                                        HStack {
                                            UserProfileImageView(url: item.userPhotoURL)
                                                .frame(width: 28, height: 28)
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
                                .opacity(visibleItems.contains(item.id) ? 1 : 0) // Apply opacity
                                .onAppear {
                                    withAnimation(.easeIn(duration: 0.5)) {
                                        visibleItems.insert(item.id) // Mark as visible with animation
                                    }
                                    
                                    if let index = self.viewModel.userPhotoItems.firstIndex(where: {$0.id == item.id}) {
                                        if index <= 9 {
                                            withAnimation {
                                                isShowingBackToTopButton = false
                                            }
                                        }
                                        
                                        if index == 9 {
                                            withAnimation {
                                                isShowingBackToTopButton = true
                                            }
                                        }
                                        
                                        
                                        
                                        if index == self.viewModel.userPhotoItems.count - 3 && !viewModel.isFetching {
                                            viewModel.loadAdditionalPhotoItems(query: !searchQuery.isEmpty ? searchQuery : "yorkshire")
                                        }
                                    }
                                }
                                
                            }
                            .id(0)
                        }
                        
                        if viewModel.isFetching {
                            ProgressView()
                        }
                        
                    }
                }
                .onAppear {
                    if !initialSearchPerformed {
                        Task {
                            await viewModel.loadInitialPhotoItems(query: "Yorkshire")
                            initialSearchPerformed = true // Set to true after initial search is done
                            isLoadingContent = false
                        }
                    }
                }
                .navigationTitle("Gallery")
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            if isShowingBackToTopButton {
                                Button(action: {
                                    withAnimation {
                                        scrollProxy.scrollTo(0, anchor: .top)
                                        isShowingBackToTopButton = false
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.up")
                                            .font(.footnote)
                                        Text("Back to Top")
                                            .fontWeight(.semibold)
                                            .font(.footnote)
                                        
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                    .shadow(radius: 2)
                                }
                                .buttonStyle(.plain)
                            }
                            
                        }
                    },
                    alignment: .bottom
                )// Overlay alignment
                
            }
            
            
            
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
    FeedView()
}
