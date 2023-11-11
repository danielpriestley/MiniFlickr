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
    @Published var userPhotoItems: [UserPhotoItem] = []
    @Published var userGalleries: [Gallery] = []
    @Published var allGalleriesLoaded = false
    
    private var hasFetchedData = false
    
    func fetchDataIfNeeded(user: User, page: Int) async {
        guard !hasFetchedData else { return }
        
        hasFetchedData = true
        
        await getUserPhotos(user: user)
        await getUserGalleries(userId: user.userInfo.nsid, page: page)
    }
    
    func loadAdditionalUserPhotoItems(user: User) {
        // enable fetching state
        isFetching = true
        
        Task {
            do {
                let newUserPhotoItems = try await network.fetchPhotosForUser(user: user, perPage: 10, page: (userPhotoItems.count / 10) + 1)
                self.userPhotoItems.append(contentsOf: newUserPhotoItems)
            } catch {
                print("An error occured while fetching new photos: \(error)")
            }
            
            // disable fetching state
            isFetching = false
        }
        
        
    }
    
    func getPhotoUrl(photo: Photo) -> URL? {
        return network.constructPhotoUrl(photo: photo)
    }
    
    
    func getUserPhotos(user: User) async {
        isFetching = true
        
        Task {
            do {
                self.userPhotoItems = try await network.fetchPhotosForUser(user: user, perPage: 10, page: 1)
                print("updated user photos")
            }
            catch {
                print("An error occured: \(error)")
            }
            
            isFetching = false
        }
        
    }
    
    func getUserGalleries(userId: String, page: Int) async {
        isFetching = true
        
        Task {
            do {
                self.userGalleries = try await network.fetchUserGalleries(userId: userId, page: page)
            } catch {
                print("An error occured: \(error)")
            }
            
            isFetching = false
        }
        
        
    }
    
    func loadAdditionalGalleries(userId: String) {
        guard !isFetching else { return }
        
        isFetching = true
        
        Task {
            do {
                let page = (userGalleries.count / 10) + 1
                let newGalleries = try await network.fetchUserGalleries(userId: userId, page: page)
                if newGalleries.isEmpty {
                    // if newGalleries is empty, we have reached the end of the galleries for a user
                    self.allGalleriesLoaded = true
                } else {
                    // Create a Set of existing galleryIds for efficient checking
                    let existingGalleryIds = Set(userGalleries.map { $0.galleryId })
                    
                    // Append only new galleries
                    let uniqueGalleries = newGalleries.filter { !existingGalleryIds.contains($0.galleryId) }
                    self.userGalleries.append(contentsOf: uniqueGalleries)
                }
            } catch {
                print("An error occurred while fetching new galleries: \(error)")
            }
            
            isFetching = false
        }
    }
    
    func getGalleryThumbnail(gallery: Gallery) -> URL? {
        return network.constructGalleryThumbnailUrl(gallery: gallery)
    }
    
}
