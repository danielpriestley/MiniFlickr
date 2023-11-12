//
//  GalleryViewModel.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 09/11/2023.
//

import Foundation

@MainActor
class GalleryViewModel: ObservableObject {
    let network = NetworkService.shared
    
    @Published var galleryPhotos: [Photo] = []
    @Published var isFetching: Bool = false
    
    func getGalleryPhotos(userId: String, galleryId: String) async {
        isFetching = true
        
        Task {
            do {
                self.galleryPhotos = try await network.fetchGalleryPhotos(userId: userId, galleryId: galleryId, perPage: 10, page: 1 )
            }
            catch {
                print("An error occured getting gallery photos: \(error)")
                throw NetworkError.failedToFetchPhotosFromGallery
            }
            
        }
        
        isFetching = false
    }
    
    func loadAdditionalGalleryPhotos(galleryId: String, userId: String) {
        isFetching = true
        
        Task {
            do {
                let newGalleryPhotos = try await network.fetchGalleryPhotos(userId: userId, galleryId: galleryId, perPage: 10, page: (galleryPhotos.count / 10) + 1)
                self.galleryPhotos.append(contentsOf: newGalleryPhotos)
            }
            catch {
                print("An error occured getting additional gallery photos: \(error)")
                throw NetworkError.failedToFetchPhotosFromGallery
            }
        }
        
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
