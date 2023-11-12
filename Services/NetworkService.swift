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
    case failedToFetchGalleriesForUser
    case failedToFetchPhotosFromGallery
    case failedToFetchPhotosForUser
    case failedToFetchPhotos
    case urlIssue
}

class NetworkService {
    static var shared = NetworkService()
    
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // MARK: Photos
    @MainActor
    func fetchPhotos(withQuery query: String, page: Int) async throws -> [Photo] {
        let decoder = JSONDecoder()
        var urlString: String
        
        if query.starts(with: "@") {
            let username = String(query.dropFirst())
            let nsid = try await fetchNsid(forUsername: username)
            
            // if the query contains @, search via the user nsid
            urlString = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Secrets.apiKey)&user_id=\(nsid)&extras=tags,date_upload,license,description,owner_name,icon_server&format=json&nojsoncallback=1&safe_search=1&page=\(page)&per_page=10"
        } else if query.contains(",") {
            // if the query contains commas, set the tag_mode to all, meaning photos must include all given tags
            urlString = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Secrets.apiKey)&tags=\(query)&tag_mode=all&extras=tags,date_upload,license,description,owner_name,icon_server&format=json&nojsoncallback=1&safe_search=1&page=\(page)&per_page=10"
        } else {
            // if the query does not contain @ or commas, proceed with a single tag search
            urlString = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Secrets.apiKey)&tags=\(query)&extras=tags,date_upload,license,description,owner_name,icon_server&format=json&nojsoncallback=1&safe_search=1&page=\(page)&per_page=10"
        }
        
        // ensure url is valid
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // fetch response from flickr
        let (data, _) = try await session.data(from: url)
        
        // attempt to decode the response to be a valid Photo type
        do {
            let photosResponse = try decoder.decode(PhotosResponse.self, from: data)
            return photosResponse.photos.photo
        } catch {
            print("Failed to decode JSON with error: \(error)")
            throw NetworkError.failedToFetchPhotos
        }
    }
    
    func fetchNsid(forUsername username: String) async throws -> String {
        let decoder = JSONDecoder()
        
        // clean username to remove commas
        let cleanedUsername = username.replacingOccurrences(of: ",", with: "")
        
        // establish url
        let nsidUrlString = "https://www.flickr.com/services/rest/?method=flickr.people.findByUsername&api_key=\(Secrets.apiKey)&username=\(cleanedUsername)&format=json&nojsoncallback=1"
        
        // ensure url is valid
        guard let nsidUrl = URL(string: nsidUrlString) else {
            throw URLError(.badURL)
        }
        
        // get the data from the endpoint
        let (data, _) = try await session.data(from: nsidUrl)
        
        // decode the response
        let apiResponse = try decoder.decode(FlickrApiResponse<FlickrUser>.self, from: data)
        
        // throw userNotFound error if no user found for that username
        if let nsid = apiResponse.user?.nsid {
            return nsid
        } else if apiResponse.stat == "fail" {
            // Handle failure according to the "code" and "message" from the response
            throw NetworkError.userNotFound
        } else {
            // If response does not contain an nsid and is not a failure, throw a generic error
            throw NetworkError.generalError
        }
        
    }
    
    @MainActor
    func fetchPhotosForUser(userId: String, currentPhotoId: String? = nil, perPage: Int, page: Int) async throws -> [Photo] {
        let decoder = JSONDecoder()
        
        // ensure url is valid
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=\(Secrets.apiKey)&format=json&nojsoncallback=1&safe_search=1&extras=tags,date_upload,license,description, owner_name,icon_server&user_id=\(userId)&per_page=\(perPage)&page=\(page)") 
        else {
            throw NetworkError.urlIssue
        }
        
        // fetch response from flickr
        let (data, _) = try await session.data(from: url)
        
        // attempt to decode the response to be a valid Photo type
        do {
            let photosResponse = try decoder.decode(PhotosResponse.self, from: data)
            
            // filter and shuffle to avoid showing the same image already within the PhotoDetailView
            let filteredPhotos = photosResponse.photos.photo.filter { $0.id != currentPhotoId }
            let shuffledPhotos = filteredPhotos.shuffled()
            let firstFivePhotos = Array(shuffledPhotos.prefix(5))
            
            return firstFivePhotos
            
        } catch {
            print("Failed to decode JSON with error: \(error)")
            throw NetworkError.failedToFetchPhotosForUser
        }
    }
    
    @MainActor
    func constructPhotoUrl(photo: Photo) -> URL? {
        let urlString = "https://live.staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
        return URL(string: urlString)
    }
    
    func constructGalleryThumbnailUrl(gallery: Gallery) -> URL? {
        let urlString = "https://live.staticflickr.com/\(gallery.primaryPhotoServer)/\(gallery.primaryPhotoId)_\(gallery.primaryPhotoSecret).jpg"
        return URL(string: urlString)
    }
    
    
    // MARK: Users
    @MainActor
    func fetchUserInfo(forUserId userId: String) async throws -> UserInfo {
        let decoder = JSONDecoder()
        
        // ensure url is valid
        guard let url = URL(string: "https://www.flickr.com/services/rest/?api_key=\(Secrets.apiKey)&format=json&nojsoncallback=1&user_id=\(userId)&method=flickr.people.getInfo")
        else {
            throw NetworkError.urlIssue
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
        guard let url = URL(string: "https://www.flickr.com/services/rest/?api_key=\(Secrets.apiKey)&format=json&nojsoncallback=1&user_id=\(userId)&method=flickr.profile.getProfile")
        else {
            throw NetworkError.urlIssue
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
    
    // https://www.flickr.com/services/api/flickr.galleries.getList.html
    @MainActor
    func fetchUserGalleries(userId: String, page: Int) async throws -> [Gallery] {
        let decoder = JSONDecoder()
        
        guard let url = URL(string: "https://www.flickr.com/services/rest/?api_key=\(Secrets.apiKey)&format=json&nojsoncallback=1&user_id=\(userId)&page=\(page)&per_page=10&method=flickr.galleries.getList")
        else {
            throw NetworkError.urlIssue
        }
        
        let (data, _) = try await session.data(from: url)
        
        do {
            let galleryResponse = try decoder.decode(GalleryResponse.self, from: data)
            return galleryResponse.galleries.gallery
        } catch {
            throw NetworkError.failedToFetchGalleriesForUser
        }
    }
    
    
    // MARK: Galleries
    @MainActor
    func fetchGalleryPhotos(userId: String, galleryId: String, perPage: Int, page: Int) async throws -> [Photo] {
        let decoder = JSONDecoder()
        
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.galleries.getPhotos&gallery_id=\(galleryId)&api_key=\(Secrets.apiKey)&format=json&nojsoncallback=1&safe_search=1&extras=tags,date_upload,license,description, owner_name,icon_server&user_id=\(userId)&per_page=\(perPage)&page=\(page)") 
        else {
            throw NetworkError.urlIssue
        }
        
        let (data, _) = try await session.data(from: url)
        
        do {
            let photosResponse = try decoder.decode(PhotosResponse.self, from: data)
            
            return photosResponse.photos.photo
        } catch {
            print("Failed to decode JSON with error: \(error)")
            throw NetworkError.failedToFetchPhotosFromGallery
        }
        
    }
}
