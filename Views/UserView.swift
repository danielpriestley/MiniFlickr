//
//  UserGalleryView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import SwiftUI

struct UserView: View {
    var user: User
    
    var body: some View {
        Text(user.userInfo.username._content)
    }
}

//#Preview {
//    UserGalleryView()
//}
