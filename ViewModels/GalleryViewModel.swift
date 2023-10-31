//
//  GalleryViewController.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import Foundation

@MainActor
class GalleryViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var isFetching: Bool = false
    
    let network = NetworkService.shared
    
    func loadInitialPhotos(query: String) {
        Task {
            do {
                self.photos = try await network.fetchPhotos(withQuery: query, page: 1)
            } catch {
                print("An error occured: \(error)")
            }
        }
    }
    
    func loadAdditionalPhotos(query: String) {
        isFetching = true // enable fetching state
        Task {
            do {
                // limiting results to 10 per page due to vertical height of image containers to increase performance
                let newPhotos = try await network.fetchPhotos(withQuery: query, page: (photos.count / 50) + 1)
                self.photos.append(contentsOf: newPhotos)
            } catch {
                print("An error occured while fetching new photos: \(error)")
            }
        }
        
        isFetching = false // disable fetching state
    }
}
