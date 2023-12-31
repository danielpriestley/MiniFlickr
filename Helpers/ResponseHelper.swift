//
//  NetworkServiceHelper.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 10/11/2023.
//

import Foundation

/// General collection of response wrappers and containers to assist with decoding JSON responses from Flickr

// MARK: Photos Helpers

struct PhotosContainer: Codable {
    let photo: [Photo]
}

struct PhotosResponse: Codable {
    let photos: PhotosContainer
}

struct PhotoUserNsidResponse: Decodable {
    struct User: Decodable {
        let nsid: String?
    }
    
    let user: User
}


// MARK: User Helpers

struct UserInfoResponse: Codable {
    let person: UserInfo
}

struct UserProfileResponse: Codable {
    let profile: ProfileInfo
}


// MARK: Gallery Helpers

struct GalleryResponse: Decodable {
    let galleries: GalleryContainer
}

struct GalleryContainer: Decodable {
    let gallery: [Gallery]
}


// MARK: Content Type Wrappers

struct NestedStringContentWrapper: Codable {
    let _content: String
}

struct NestedNumberContentWrapper: Codable {
    let _content: Int
}

// MARK: Flickr response for getting an nsid from username
struct FlickrApiResponse<T: Codable>: Codable {
    let stat: String
    let code: Int?
    let message: String?
    let user: T?
    
    enum CodingKeys: String, CodingKey {
        case stat, code, message, user
    }
}

struct FlickrUser: Codable {
    let nsid: String?
}
