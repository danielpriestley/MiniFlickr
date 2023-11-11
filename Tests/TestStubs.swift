//
//  TestStubs.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import Foundation

enum TestStubs {
    static let fetchPhotosSuccessResponse =
        """
        {
            "photos": {
                "page": 2,
                "pages": 3685,
                "perpage": 3,
                "total": 11055,
                "photo": [
                    {
                        "id": "53300058811",
                        "owner": "23511776@N08",
                        "secret": "b0885889f5",
                        "server": "65535",
                        "farm": 66,
                        "title": "iP14-14369a",
                        "ispublic": 1,
                        "isfriend": 0,
                        "isfamily": 0,
                        "license": "0",
                        "description": {
                            "_content": ""
                        },
                        "dateupload": "1698764453",
                        "ownername": "Sou'wester",
                        "iconserver": "3768",
                        "iconfarm": 4,
                        "tags": "kelpies artwork installation forthclyde canal scotland falkirk helix park sculpture horses equine grangemouth river carron forth queenelizabethiicanal"
                    },
                    {
                        "id": "53300058841",
                        "owner": "23511776@N08",
                        "secret": "5fde0854b3",
                        "server": "65535",
                        "farm": 66,
                        "title": "iP14-14374a",
                        "ispublic": 1,
                        "isfriend": 0,
                        "isfamily": 0,
                        "license": "0",
                        "description": {
                            "_content": ""
                        },
                        "dateupload": "1698764452",
                        "ownername": "Sou'wester",
                        "iconserver": "3768",
                        "iconfarm": 4,
                        "tags": "kelpies artwork installation forthclyde canal scotland falkirk helix park sculpture horses equine grangemouth river carron forth queenelizabethiicanal"
                    },
                    {
                        "id": "53300058756",
                        "owner": "23511776@N08",
                        "secret": "6314660a17",
                        "server": "65535",
                        "farm": 66,
                        "title": "iP14-14385a",
                        "ispublic": 1,
                        "isfriend": 0,
                        "isfamily": 0,
                        "license": "0",
                        "description": {
                            "_content": ""
                        },
                        "dateupload": "1698764452",
                        "ownername": "Sou'wester",
                        "iconserver": "3768",
                        "iconfarm": 4,
                        "tags": "kelpies artwork installation forthclyde canal scotland falkirk helix park sculpture horses equine grangemouth river carron forth queenelizabethiicanal"
                    }
                ]
            },
            "stat": "ok"
        }
        """
    
    static let fetchPhotosByUsernameResponse = 
    """
    
    """
}
