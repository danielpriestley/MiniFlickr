//
//  Photo.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import Foundation
import Observation

struct Photo: Codable, Identifiable, Equatable {
    let id: String
    let owner: String
    let title: String
    let secret: String
    let server: String
    let farm: Int
    let tags: String?
    var description: NestedStringContentWrapper
    let license: String
    let dateupload: String
    let ownername: String
    let iconserver: String
    
    var descriptionContent: String {
        return description._content
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}

struct PhotoInfo: Codable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
    let originalformat: String
}
