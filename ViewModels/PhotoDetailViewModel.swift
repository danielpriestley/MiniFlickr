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
        guard let tagsString = photo.tags?.trimmingCharacters(in: .whitespacesAndNewlines),
              !tagsString.isEmpty else {
            return []
        }

        let allTags = tagsString.components(separatedBy: " ").filter { !$0.isEmpty }
        let finalTags = Array(allTags.prefix(tagAmount))
        return finalTags
    }
    
    func getMorePhotosFromUser(userId: String, currentPhotoId: String) async {
        Task {
            do {
                self.userPhotos = try await network.fetchPhotosForUser(userId: userId, currentPhotoId: currentPhotoId, perPage: 20, page: 1)
            }
            catch {
                print("An error occured: \(error)")
            }
        }
    }
}



