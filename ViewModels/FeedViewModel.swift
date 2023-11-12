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
    @Published var isFetching: Bool = false
    
    let network = NetworkService.shared
    
    func loadInitialPhotoItems(query: String) async {
        Task {
            do {
                self.photos = try await network.fetchPhotos(withQuery: query, page: 1)
            } catch {
                print("An error occured: \(error)")
                throw NetworkError.failedToFetchPhotos
            }
        }
    }
    
    func loadAdditionalPhotoItems(query: String) {
        // enable fetching state
        isFetching = true
        
        Task {
            do {
                let photoItems = try await network.fetchPhotos(withQuery: query, page: (photos.count / 10) + 1)
                self.photos.append(contentsOf: photoItems)
            } catch {
                print("An error occured while fetching new photos: \(error)")
                throw NetworkError.failedToFetchPhotos
            }
        }
        
        // disable fetching state
        isFetching = false
    }
    
    
    func getPhotoUrl(photo: Photo) -> URL? {
        return network.constructPhotoUrl(photo: photo)
    }
    
    func getTagsFromPhoto(photo: Photo, tagAmount: Int) -> [String] {
        guard let tagsString = photo.tags?.trimmingCharacters(in: .whitespacesAndNewlines),
              !tagsString.isEmpty else {
            return []
        }

        let allTags = tagsString.components(separatedBy: " ").filter { !$0.isEmpty }
        let finalTags = Array(allTags.prefix(tagAmount))
        return finalTags
    }
}
