//
//  MiniFlickrApp.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import SwiftUI
import TipKit

@main
struct MiniFlickrApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    // configure tips at app launch
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
        
    }
}
