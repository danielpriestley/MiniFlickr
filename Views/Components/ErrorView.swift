//
//  ErrorView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 13/11/2023.
//

import SwiftUI

struct ErrorView: View {
    var error: NetworkError
    
    var body: some View {
            VStack {
                Image(systemName: "x.circle")
                    .resizable()
                    .foregroundStyle(.red)
                    .frame(width: 44, height: 44)
                Text("An error occurred.")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 8)
                Text(error.errorMessage)
                    .padding(.horizontal)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.top)
    }
}


