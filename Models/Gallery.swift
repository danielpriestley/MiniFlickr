//
//  Gallery.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 06/11/2023.
//

import Foundation

struct Gallery: Identifiable, Decodable {
    let id: String
    let galleryId: String
    let primaryPhotoId: String
    let photoCount: Int
    let viewCount: Int
    let title: NestedStringContentWrapper
    let description: NestedStringContentWrapper
    let primaryPhotoServer: String
    let primaryPhotoFarm: Int
    let primaryPhotoSecret: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case galleryId = "gallery_id"
        case primaryPhotoId = "primary_photo_id"
        case photoCount = "count_photos"
        case viewCount = "count_views"
        case title
        case description
        case primaryPhotoServer = "primary_photo_server"
        case primaryPhotoFarm = "primary_photo_farm"
        case primaryPhotoSecret = "primary_photo_secret"
        
    }
}


