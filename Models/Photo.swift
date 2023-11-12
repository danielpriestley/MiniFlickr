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
    
    // https://www.flickr.com/services/api/misc.buddyicons.html
    var profileImageUrl: URL {
        // if the icon server exists, they should have a profile image
        if let iconServerInt = Int(iconserver), iconServerInt > 0 {
            return URL(string: "https://farm\(farm).staticflickr.com/\(iconServerInt)/buddyicons/\(owner).jpg")!
        } else {
            // if the icon server doesn't exist (it has a value of 0), return the default icon
            return URL(string: "https://www.flickr.com/images/buddyicon.gif")!
        }
    }
    
    var uploadDate: String {
        let date = Date(timeIntervalSince1970: Double(dateupload) ?? 0)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd•MM•yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}
