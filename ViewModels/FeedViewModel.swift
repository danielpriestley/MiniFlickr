//
//  GalleryViewController.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import Foundation

@MainActor
class FeedViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var userPhotoItems: [UserPhotoItem] = []
    @Published var isFetching: Bool = false
    
    let network = NetworkService.shared
    
    func loadInitialPhotoItems(query: String) async {
        Task {
            do {
                self.userPhotoItems = try await network.fetchUserPhotoItems(withQuery: query, page: 1)
            } catch {
                print("An error occured: \(error)")
            }
        }
    }
    
    func loadAdditionalPhotoItems(query: String) {
        // enable fetching state
        isFetching = true
        
        Task {
            do {
                let newUserPhotoItems = try await network.fetchUserPhotoItems(withQuery: query, page: (userPhotoItems.count / 10) + 1)
                self.userPhotoItems.append(contentsOf: newUserPhotoItems)
            } catch {
                print("An error occured while fetching new photos: \(error)")
            }
        }
        
        // disable fetching state
        isFetching = false
    }
    
    
    func getPhotoUrl(photo: Photo) -> URL? {
        return network.constructPhotoUrl(photo: photo)
    }
    
    func getTagsFromPhoto(photo: Photo, tagAmount: Int) -> [String] {
        guard let tagsString = photo.tags else {
            return []
        }
        
        let allTags = tagsString.components(separatedBy: " ")
        let finalTags = Array(allTags.prefix(tagAmount))
        return finalTags
    }
}
