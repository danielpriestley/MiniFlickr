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
    
    static let nsidLookupResponse =
    """
        {
            "user": {
                "id": "66956608@N06",
                "nsid": "66956608@N06",
                "username": {
                    "_content": "Flickr"
                }
            },
            "stat": "ok"
        }
    """
    
    static let nsidNotFoundResponse =
    """
    {
        "stat": "fail",
        "code": 1,
        "message": "User not found"
    }
    """
    
    static let fetchPhotosByUsernameResponse =
    """
    {
        "photos": {
            "page": 1,
            "pages": 347,
            "perpage": 3,
            "total": 1040,
            "photo": [
                {
                    "id": "53322715959",
                    "owner": "66956608@N06",
                    "secret": "2233ab274b",
                    "server": "65535",
                    "farm": 66,
                    "title": "Weekly Snapshot-11/10/23",
                    "ispublic": 1,
                    "isfriend": 0,
                    "isfamily": 0,
                    "license": "0",
                    "description": {
                        "_content": "Description content"
                    },
                    "dateupload": "1699625586",
                    "ownername": "Flickr",
                    "iconserver": "3741",
                    "iconfarm": 4,
                    "tags": ""
                },
                {
                    "id": "53314131381",
                    "owner": "66956608@N06",
                    "secret": "36b52aa594",
                    "server": "65535",
                    "farm": 66,
                    "title": "Mark your calendars!",
                    "ispublic": 1,
                    "isfriend": 0,
                    "isfamily": 0,
                    "license": "0",
                    "description": {
                        "_content": "Description content"
                    },
                    "dateupload": "1699297937",
                    "ownername": "Flickr",
                    "iconserver": "3741",
                    "iconfarm": 4,
                    "tags": ""
                },
                {
                    "id": "53307263923",
                    "owner": "66956608@N06",
                    "secret": "f247380acb",
                    "server": "65535",
                    "farm": 66,
                    "title": "Get to know Flickr Galleries",
                    "ispublic": 1,
                    "isfriend": 0,
                    "isfamily": 0,
                    "license": "0",
                    "description": {
                        "_content": "Description content"
                    },
                    "dateupload": "1699024580",
                    "ownername": "Flickr",
                    "iconserver": "3741",
                    "iconfarm": 4,
                    "tags": ""
                }
            ]
        },
        "stat": "ok"
    }
    """
    
    static let fetchUserInfoSuccessResponse =
    """
    {
        "person": {
            "id": "66956608@N06",
            "nsid": "66956608@N06",
            "ispro": 1,
            "is_deleted": 0,
            "iconserver": "3741",
            "iconfarm": 4,
            "path_alias": "flickr",
            "has_stats": 0,
            "pro_badge": "legacy",
            "expire": "1959006224",
            "username": {
                "_content": "Flickr"
            },
            "realname": {
                "_content": "Flickr"
            },
            "location": {
                "_content": ""
            },
            "timezone": {
                "label": "Pacific Time (US & Canada); Tijuana",
                "offset": "-08:00",
                "timezone_id": "PST8PDT",
                "timezone": 5
            },
            "description": {
                "_content": "Welcome to the official Flickr account on Flickr."
            },
            "photosurl": {
                "_content": "https://www.flickr.com/photos/flickr/"
            },
            "profileurl": {
                "_content": "https://www.flickr.com/people/flickr/"
            },
            "mobileurl": {
                "_content": "https://m.flickr.com/photostream.gne?id=66911286"
            },
            "photos": {
                "firstdatetaken": {
                    "_content": "2010-06-05 14:14:59"
                },
                "firstdate": {
                    "_content": "1361127587"
                },
                "count": {
                    "_content": 1040
                }
            },
            "has_adfree": 0,
            "has_free_standard_shipping": 0,
            "has_free_educational_resources": 0
        },
        "stat": "ok"
    }
    """
    
    static let fetchProfileInfoSuccessResponse =
    """
    {
        "profile": {
            "id": "66956608@N06",
            "nsid": "66956608@N06",
            "join_date": "1076443200",
            "occupation": "",
            "hometown": "San Francisco",
            "showcase_set": "72157677399602224",
            "showcase_set_title": "Profile Showcase",
            "first_name": "Flickr",
            "last_name": "",
            "profile_description": "Welcome to the official Flickr account on Flickr.",
            "website": "https://www.flickr.com",
            "city": "",
            "country": "",
            "facebook": "flickr",
            "twitter": "Flickr",
            "tumblr": "flickr",
            "instagram": "flickr",
            "pinterest": "flickr"
        },
        "stat": "ok"
    }
    """
    
    static let fetchPhotosForUserSuccessResponse =
    """
    {
        "photos": {
            "page": 1,
            "pages": 347,
            "perpage": 3,
            "total": 1040,
            "photo": [
                {
                    "id": "53322715959",
                    "owner": "66956608@N06",
                    "secret": "2233ab274b",
                    "server": "65535",
                    "farm": 66,
                    "title": "Weekly Snapshot-11/10/23",
                    "ispublic": 1,
                    "isfriend": 0,
                    "isfamily": 0,
                    "license": "0",
                    "description": {
                        "_content": "Description content"
                    },
                    "dateupload": "1699625586",
                    "ownername": "Flickr",
                    "iconserver": "3741",
                    "iconfarm": 4,
                    "tags": ""
                },
                {
                    "id": "53314131381",
                    "owner": "66956608@N06",
                    "secret": "36b52aa594",
                    "server": "65535",
                    "farm": 66,
                    "title": "Mark your calendars!",
                    "ispublic": 1,
                    "isfriend": 0,
                    "isfamily": 0,
                    "license": "0",
                    "description": {
                        "_content": "Description content"
                    },
                    "dateupload": "1699297937",
                    "ownername": "Flickr",
                    "iconserver": "3741",
                    "iconfarm": 4,
                    "tags": ""
                },
                {
                    "id": "53307263923",
                    "owner": "66956608@N06",
                    "secret": "f247380acb",
                    "server": "65535",
                    "farm": 66,
                    "title": "Get to know Flickr Galleries",
                    "ispublic": 1,
                    "isfriend": 0,
                    "isfamily": 0,
                    "license": "0",
                    "description": {
                        "_content": "Description content"
                    },
                    "dateupload": "1699024580",
                    "ownername": "Flickr",
                    "iconserver": "3741",
                    "iconfarm": 4,
                    "tags": ""
                }
            ]
        },
        "stat": "ok"
    }
    """
    
    static let fetchUserGalleriesSuccessResponse =
    """
    {
        "galleries": {
            "total": 3,
            "per_page": 3,
            "user_id": "63087892@N04",
            "page": 1,
            "pages": 1,
            "gallery": [
                {
                    "id": "63055753-72157720083775277",
                    "gallery_id": "72157720083775277",
                    "url": "https://www.flickr.com/photos/tick-my_pictures/galleries/72157720083775277",
                    "owner": "63087892@N04",
                    "username": "tickspics",
                    "iconserver": "7926",
                    "iconfarm": 8,
                    "primary_photo_id": "50607475588",
                    "date_create": "1635269821",
                    "date_update": "1635269861",
                    "count_photos": 5,
                    "count_videos": 0,
                    "count_total": 0,
                    "count_views": 4,
                    "count_comments": 0,
                    "title": {
                        "_content": "Insects"
                    },
                    "description": {
                        "_content": ""
                    },
                    "sort_group": null,
                    "primary_photo_server": "65535",
                    "primary_photo_farm": 66,
                    "primary_photo_secret": "2304f903ea"
                },
                {
                    "id": "63055753-72157710693097407",
                    "gallery_id": "72157710693097407",
                    "url": "https://www.flickr.com/photos/tick-my_pictures/galleries/72157710693097407",
                    "owner": "63087892@N04",
                    "username": "tickspics",
                    "iconserver": "7926",
                    "iconfarm": 8,
                    "primary_photo_id": "17015575675",
                    "date_create": "1567625413",
                    "date_update": "1659298518",
                    "count_photos": 17,
                    "count_videos": 0,
                    "count_total": 0,
                    "count_views": 62,
                    "count_comments": 1,
                    "title": {
                        "_content": "Bears"
                    },
                    "description": {
                        "_content": ""
                    },
                    "sort_group": null,
                    "primary_photo_server": "8709",
                    "primary_photo_farm": 9,
                    "primary_photo_secret": "6fd48cd36f"
                },
                {
                    "id": "63055753-72157699485519681",
                    "gallery_id": "72157699485519681",
                    "url": "https://www.flickr.com/photos/tick-my_pictures/galleries/72157699485519681",
                    "owner": "63087892@N04",
                    "username": "tickspics",
                    "iconserver": "7926",
                    "iconfarm": 8,
                    "primary_photo_id": "48641661796",
                    "date_create": "1536342970",
                    "date_update": "1668547823",
                    "count_photos": 50,
                    "count_videos": 0,
                    "count_total": 0,
                    "count_views": 101,
                    "count_comments": 3,
                    "title": {
                        "_content": "Africa"
                    },
                    "description": {
                        "_content": ""
                    },
                    "sort_group": null,
                    "primary_photo_server": "65535",
                    "primary_photo_farm": 66,
                    "primary_photo_secret": "7a8085a542"
                }
            ]
        },
        "stat": "ok"
    }
    """
    
    static let fetchUserGalleriesNoGalleriesResponse =
    """
    {
        "galleries": {
            "total": 0,
            "per_page": 0,
            "user_id": "61969044@N07",
            "page": 1,
            "pages": 1,
            "gallery": []
        },
        "stat": "ok"
    }
    """
    
    static let fetchGalleryPhotosSuccessResponse =
    """
    {
        "photos": {
            "page": 1,
            "pages": 7618,
            "perpage": 3,
            "total": 22853,
            "photo": [
                {
                    "id": "53325191273",
                    "owner": "8070463@N03",
                    "secret": "373deb18ee",
                    "server": "65535",
                    "farm": 66,
                    "title": "Jasmina quite serious",
                    "ispublic": 1,
                    "isfriend": 0,
                    "isfamily": 0,
                    "license": "6",
                    "description": {
                        "_content": "On this picture, she was looking at me quite calmly"
                    },
                    "dateupload": "1699729336",
                    "ownername": "Tambako the Jaguar",
                    "iconserver": "7457",
                    "iconfarm": 8,
                    "tags": "animal big bigcat calm cat close closeup crémines cute d6 face female grass jura lying mammal nikon observing portrait relaxing resting sikypark switzerland tiger tigress vegetation wild"
                },
                {
                    "id": "53324493874",
                    "owner": "8070463@N03",
                    "secret": "c7f053f343",
                    "server": "65535",
                    "farm": 66,
                    "title": "Jasmina crouching and showing tongue",
                    "ispublic": 1,
                    "isfriend": 0,
                    "isfamily": 0,
                    "license": "6",
                    "description": {
                        "_content": "She was posing in differnt positions just for me! ;)"
                    },
                    "dateupload": "1699700409",
                    "ownername": "Tambako the Jaguar",
                    "iconserver": "7457",
                    "iconfarm": 8,
                    "tags": "animal attentive big bigcat cat close closeup crouching crémines cute d6 face female grass jura looking lying mammal nikon openmouth portrait posing pretty relaxing resting sikypark sunny switzerland tiger tigress tiongue tongue vegetation wild"
                },
                {
                    "id": "53323359290",
                    "owner": "8070463@N03",
                    "secret": "77c86295af",
                    "server": "65535",
                    "farm": 66,
                    "title": "Tima looking a bit up",
                    "ispublic": 1,
                    "isfriend": 0,
                    "isfamily": 0,
                    "license": "6",
                    "description": {
                        "_content": ""
                    },
                    "dateupload": "1699642880",
                    "ownername": "Tambako the Jaguar",
                    "iconserver": "7457",
                    "iconfarm": 8,
                    "tags": "animal attentive big bigcat cat close crémines d6 face female jura lion lioness looking lookingup mammal nikon observing old portrait pretty sikypark standing switzerland upwards vegetation wild"
                }
            ]
        },
        "stat": "ok"
    }
    """

    
    
}
