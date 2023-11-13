//
//  NetworkError.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 13/11/2023.
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
    case failedToFetchTags
    case failedToFetchRemoteImage
    case urlIssue
    
    var errorMessage: String {
        switch self {
        case .userNotFound:
            return "User not found."
        case .generalError:
            return "A general error occurred."
        case .failedToFetchProfileInfo:
            return "Failed to fetch profile information."
        case .failedToFetchUserInfo:
            return "Failed to fetch user information."
        case .failedToFetchGalleriesForUser:
            return "Failed to fetch galleries for this user."
        case .failedToFetchPhotosFromGallery:
            return "Failed to fetch photos from this gallery."
        case .failedToFetchPhotosForUser:
            return "Failed to fetch photos for this user."
        case .failedToFetchPhotos:
            return "Failed to fetch photos."
        case .failedToFetchTags:
            return "Failed to fetch tags."
        case .failedToFetchRemoteImage:
            return "Failed to fetch remote image."
        case .urlIssue:
            return "There was an issue with the URL."
        }
    }
}
