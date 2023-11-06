//
//  ImageDetailViewController.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import Foundation

@MainActor
class PhotoDetailViewModel: ObservableObject {
    let network = NetworkService.shared
    
    @Published var userPhotos: [Photo] = []
    
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
    
    func getMorePhotosFromUser(userId: String) async {
        Task {
            do {
                self.userPhotos = try await network.fetchMoreUserPhotos(userId: userId)
                print("updated user photos")
            }
            catch {
                print("An error occured: \(error)")
            }
        }
    }
}



