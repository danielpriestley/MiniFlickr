//
//  NetworkService.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
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
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // attempt to decode the response to be a valid Photo type
        do {
            let photosResponse = try decoder.decode(PhotosResponse.self, from: data)
            return photosResponse.photos.photo
        } catch {
            print("Failed to decode JSON with error: \(error)")
            throw error
        }
    }
    
    
    
    
}
