//
//  UserPhotoItem.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 01/11/2023.
//

import Foundation

struct UserPhotoItem: Identifiable, Equatable {
    let photo: Photo
    let user: User
    
    // computed properties here allow for abstraction from the underlying Photo and User so that the UI doesn't need to know the full structure of those models
    var photoTitle: String {
        return photo.title
    }
    
    var userPhotoURL: URL {
        return user.buddyIconURL
    }
    
    var username: String {
        return user.userInfo.username._content
    }
    
//    var server: String {
//        return photo.server
//    }
//    
//    var farm: String {
//        return String(from: photo.farm)
//    }
    
    // create id to adhere to identifable protocol
    var id: String {
        return "\(photo.id)\(user.userInfo.id)"
    }
    
    static func == (lhs: UserPhotoItem, rhs: UserPhotoItem) -> Bool {
        return lhs.id == rhs.id
    }
}
