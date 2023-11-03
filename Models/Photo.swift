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
}
