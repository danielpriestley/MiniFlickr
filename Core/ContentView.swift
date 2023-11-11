//
//  ContentView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FeedView()
            .navigationTitle("Photos")
    }
}

#Preview {
    ContentView()
}
