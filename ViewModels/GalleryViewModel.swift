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
    @Published var userPhotoItems: [UserPhotoItem] = []
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
    
    func loadInitialPhotoItems(query: String) {
        Task {
            do {
                self.userPhotoItems = try await network.fetchUserPhotoItems(forQuery: query, page: 1)
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
               // limiting results to 30 per page for performance
                let newPhotos = try await network.fetchPhotos(withQuery: query, page: (photos.count / 30) + 1)
                self.photos.append(contentsOf: newPhotos)
            } catch {
                print("An error occured while fetching new photos: \(error)")
            }
        }
        
        // disable fetching state
        isFetching = false
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
