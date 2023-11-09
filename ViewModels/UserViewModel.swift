//
//  UserGalleryViewController.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import Foundation

@MainActor
class UserViewModel: ObservableObject {
    let network = NetworkService.shared
    
    @Published var isFetching: Bool = false
    @Published var userPhotos: [UserPhotoItem] = []
    @Published var userGalleries: [Gallery] = []
    
    func loadAdditionalUserPhotos(user: User) {
        // enable fetching state
        isFetching = true
        
        Task {
            do {
                let newUserPhotoItems = try await network.fetchPhotosForUser(user: user, perPage: 10, page: (userPhotos.count / 10) + 1)
                self.userPhotos.append(contentsOf: newUserPhotoItems)
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
    
    
    func getUserPhotos(user: User) async {
        Task {
            do {
                self.userPhotos = try await network.fetchPhotosForUser(user: user, perPage: 10, page: 1)
                print("updated user photos")
            }
            catch {
                print("An error occured: \(error)")
            }
        }
    }
    
    func getUserGalleries(userId: String) async {
        Task {
            do {
                self.userGalleries = try await network.fetchUserGalleries(userId: userId)
            } catch {
                print("An error occured: \(error)")
            }
        }
    }
    
    func getGalleryThumbnail(gallery: Gallery) -> URL? {
        return network.constructGalleryThumbnailUrl(gallery: gallery)
    }

}
