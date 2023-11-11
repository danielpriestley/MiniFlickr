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
    
    @Published var galleryPhotos: [UserPhotoItem] = []
    @Published var isFetching: Bool = false
    
    func getGalleryPhotos(user: User, galleryId: String) async {
        isFetching = true
        
        Task {
            do {
                self.galleryPhotos = try await network.fetchGalleryPhotos(user: user, galleryId: galleryId, perPage: 10, page: 1 )
                print("Loaded initial gallery photos")
            }
            catch {
                print("An error occured getting gallery photos: \(error)")
            }
            
        }
        
        isFetching = false
    }
    
    func loadAdditionalGalleryPhotos(galleryId: String, user: User) {
        isFetching = true
        
        Task {
            do {
                let newGalleryPhotos = try await network.fetchGalleryPhotos(user: user, galleryId: galleryId, perPage: 10, page: (galleryPhotos.count / 10) + 1)
                self.galleryPhotos.append(contentsOf: newGalleryPhotos)
                print("Loaded additional gallery photos")
            }
            catch {
                print("An error occured getting additional gallery photos: \(error)")
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
