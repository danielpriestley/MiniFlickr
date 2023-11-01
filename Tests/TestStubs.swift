//
//  TestStubs.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import Foundation

enum TestStubs {
    static let fetchPhotosResponse = """
        {
            "photos": {
                "page": 2,
                "pages": 1522,
                "perpage": 100,
                "total": 152171,
                "photo": [
                    {
                        "id": "53295906315",
                        "owner": "26695575@N07",
                        "secret": "7c657a40fe",
                        "server": "65535",
                        "farm": 66,
                        "title": "The Wall",
                        "ispublic": 1,
                        "isfriend": 0,
                        "isfamily": 0
                    },
                    {
                        "id": "53295679183",
                        "owner": "26695575@N07",
                        "secret": "f1093031e4",
                        "server": "65535",
                        "farm": 66,
                        "title": "Roots",
                        "ispublic": 1,
                        "isfriend": 0,
                        "isfamily": 0
                    },
                    {
                        "id": "53295433751",
                        "owner": "26695575@N07",
                        "secret": "1a7b728415",
                        "server": "65535",
                        "farm": 66,
                        "title": "Thornton Beck",
                        "ispublic": 1,
                        "isfriend": 0,
                        "isfamily": 0
                    },
                ]
            }
        }
        """
}
