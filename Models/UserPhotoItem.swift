//
//  UserPhotoItem.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 01/11/2023.
//

import Foundation

struct UserPhotoItem: Identifiable, Equatable {
    let id = UUID()
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
    
    var uploadDate: String {
        let date = Date(timeIntervalSince1970: Double(photo.dateupload) ?? 0)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd•MM•yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    static func == (lhs: UserPhotoItem, rhs: UserPhotoItem) -> Bool {
        return lhs.id == rhs.id
    }
}
