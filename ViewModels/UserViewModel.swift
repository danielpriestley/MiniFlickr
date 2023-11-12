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
    @Published var photos: [Photo] = []
    @Published var userGalleries: [Gallery] = []
    @Published var allGalleriesLoaded = false
    @Published var user: User?
    
    private var hasFetchedData = false
    
    func fetchDataIfNeeded(userId: String, page: Int) async {
        guard !hasFetchedData else { return }
        
        hasFetchedData = true
        
        await getUser(userId: userId)
        await getUserGalleries(userId: userId, page: page)
        await getUserPhotos(userId: userId)
        
    }
    
    func getUser(userId: String) async {
        Task {
            do {
                self.user = try await network.fetchCompleteUserInfo(forUserId: userId)
            } catch {
                throw NetworkError.failedToFetchUserInfo
            }
        }
    }
    
    func loadAdditionalPhotos(userId: String) {
        // enable fetching state
        isFetching = true
        
        Task {
            do {
                let newPhotos = try await network.fetchPhotosForUser(userId: userId, perPage: 10, page: (photos.count / 10) + 1)
                self.photos.append(contentsOf: newPhotos)
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
    
    
    func getUserPhotos(userId: String) async {
        isFetching = true
        
        Task {
            do {
                self.photos = try await network.fetchPhotosForUser(userId: userId, perPage: 10, page: 1)
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
