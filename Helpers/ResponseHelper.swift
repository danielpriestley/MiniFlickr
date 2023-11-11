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

struct PhotoInfoResponse: Codable {
    let photo: PhotoInfo
}

struct PhotoUserNsidResponse: Decodable {
    struct User: Decodable {
        let nsid: String
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
