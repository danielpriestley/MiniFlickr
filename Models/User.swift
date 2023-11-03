//
//  User.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 01/11/2023.
//

import Foundation

struct UserInfoResponse: Codable {
    let person: UserInfo
}

struct UserProfileResponse: Codable {
    let profile: ProfileInfo
}

struct UserInfo: Codable {
    let id: String
    let nsid: String
    let username: NestedContentWrapper
    let iconServer: String?
    let iconFarm: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case nsid
        case username
        case iconServer = "iconserver"
        case iconFarm = "iconfarm"
    }
}

struct NestedContentWrapper: Codable {
    let _content: String
}

struct ProfileInfo: Codable {
    // additional profile info
    var occupation: String?
    var description: NestedContentWrapper?
    var city: String?
    var firstName: String?
    var lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case occupation
        case description
        case city
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
}


struct User: Codable {
    let userInfo: UserInfo
    let profileInfo: ProfileInfo
    
    // https://www.flickr.com/services/api/misc.buddyicons.html
    var buddyIconURL: URL {
        // if the icon server exists, they should have a profile image
        if let iconServerInt = Int(userInfo.iconServer ?? "0"), iconServerInt > 0 {
            return URL(string: "https://farm\(userInfo.iconFarm).staticflickr.com/\(iconServerInt)/buddyicons/\(userInfo.nsid).jpg")!
        } else {
            // if the icon server doesn't exist (it has a value of 0), return the default icon
            return URL(string: "https://www.flickr.com/images/buddyicon.gif")!
        }
        
        
    }
}
