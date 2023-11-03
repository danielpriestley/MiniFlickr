//
//  NetworkService.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import Foundation

enum NetworkError: Error {
    case userNotFound
    case generalError
    case failedToFetchProfileInfo
    case failedToFetchUserInfo
}

class NetworkService {
    static var shared = NetworkService()
    
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // MARK: Fetching Photos
    
    // container + response to match JSON response for use in decoding
    struct PhotosContainer: Codable {
        let photo: [Photo]
    }
    
    struct PhotosResponse: Codable {
        let photos: PhotosContainer
    }
    
    @MainActor
    func fetchPhotos(withQuery query: String, page: Int) async throws -> [Photo] {
        let decoder = JSONDecoder()
        
        // ensure url is valid
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Secrets.apiKey)&tags=\(query)&format=json&nojsoncallback=1&safe_search=1&page=\(page)&per_page=50")
        else {
            fatalError("Invalid URL")
        }
        
        // fetch response from flickr
        let (data, _) = try await session.data(from: url)
        
        // attempt to decode the response to be a valid Photo type
        do {
            let photosResponse = try decoder.decode(PhotosResponse.self, from: data)
            return photosResponse.photos.photo
        } catch {
            print("Failed to decode JSON with error: \(error)")
            throw error
        }
    }
    
    
    // MARK: Fetching User Info
    
    @MainActor
    func fetchUserInfo(forUserId userId: String) async throws -> UserInfo {
        let decoder = JSONDecoder()
        
        // ensure url is valid
        guard let url = URL(string: "https://www.flickr.com/services/rest/?api_key=\(Secrets.apiKey)&format=json&nojsoncallback=1&user_id=\(userId)&method=flickr.people.getInfo")
        else {
            fatalError("Invalid URL")
        }
        
        let (data, _) = try await session.data(from: url)
        
        // decode the response from flickr
        let userInfoResponse = try decoder.decode(UserInfoResponse.self, from: data)
        return userInfoResponse.person
    }
    
    @MainActor
    func fetchProfileInfo(forUserId userId: String) async throws -> ProfileInfo {
        let decoder = JSONDecoder()
        
        // ensure url is valid
        guard let url = URL(string:
                                "https://www.flickr.com/services/rest/?api_key=\(Secrets.apiKey)&format=json&nojsoncallback=1&user_id=\(userId)&method=flickr.profile.getProfile")
        else {
            fatalError("Invalid URL")
        }
        
        let (data, _) = try await session.data(from: url)
        
        // decode the response from flickr
        let userProfileResponse = try decoder.decode(UserProfileResponse.self, from: data)
        return userProfileResponse.profile
    }
    
    @MainActor
    func fetchCompleteUserInfo(forUserId userId: String) async throws -> User {
        var userInfo: UserInfo?
        var profileInfo: ProfileInfo?
        
        // fetch the basic info such as the nsid, server, farm etc for buddyicon
        do {
            userInfo = try await fetchUserInfo(forUserId: userId)
        } catch {
            print("Error while fetching basic user info: \(error)")
            throw NetworkError.failedToFetchUserInfo
        }
        
        do {
            profileInfo = try await fetchProfileInfo(forUserId: userId)
        } catch {
            print("Error while fetching user profile info: \(error)")
            throw NetworkError.failedToFetchProfileInfo
        }
        
        guard let fetchedUserInfo = userInfo, let fetchedProfileInfo = profileInfo else {
            throw NetworkError.userNotFound
        }
        
        return User(userInfo: fetchedUserInfo, profileInfo: fetchedProfileInfo)
        
    }
    
    
    
    
    // MARK: Fetching UserPhotoItems\
    
    @MainActor
    func fetchUserPhotoItems(forQuery query: String, page: Int) async throws -> [UserPhotoItem] {
        let photos = try await fetchPhotos(withQuery: query, page: page)
        
        var userProfiles: [String: User] = [:]
        
        // map out unique user ids
        let uniqueUserIds = Set(photos.map{$0.owner})
        
        // fetch the user profiles in parallel to fetching the photos
        await withTaskGroup(of: (String, User?)?.self) { group in
            for userId in uniqueUserIds {
                group.addTask { [weak self] in
                    do {
                        let user = try await self?.fetchCompleteUserInfo(forUserId: userId)
                        return (userId, user)
                    } catch {
                        print("Error fetching user info for \(userId): \(error)")
                        return nil
                    }
                }
            }
            
            for await result in group {
                if let (userId, user) = result {
                    userProfiles[userId] = user
                }
            }
        }
        
        // map photos to the UserPhotoItem
        return photos.compactMap { photo in
            if let userProfile = userProfiles[photo.owner] {
                return UserPhotoItem(photo: photo, user: userProfile)
            } else {
                print("user profile not found for \(photo.owner)")
                return nil
            }
        }
        
        
    }
    
    
    
    
    
    
}
