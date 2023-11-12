//
//  NetworkServiceTests.swift
//  MiniFlickrTests
//
//  Created by Daniel Priestley on 31/10/2023.
//

import XCTest
@testable import MiniFlickr

final class NetworkServiceTests: XCTestCase {
    var mockSession: MockURLSession!
    var networkService: NetworkService!
    
    // setUp and tearDown allow for NetworkService to be set and reset between tests
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkService = NetworkService(session: mockSession)
    }
    
    override func tearDown() {
        mockSession = nil
        networkService = nil
        super.tearDown()
    }
    
    // MARK: Fetching photos by query
    func testFetchPhotosSuccess() async throws {
        // given
        mockSession.mockedData = TestStubs.fetchPhotosSuccessResponse.data(using: .utf8)
        
        
        do {
            // when
            let photos = try await networkService.fetchPhotos(withQuery: "grangemouth", page: 2)
            
            // then
            XCTAssertNotNil(photos, "Expected photos to not be nil")
            XCTAssert(photos.count > 0, "Expected at least one photo in the response")
            
            if let firstPhoto = photos.first {
                XCTAssertNotNil(firstPhoto.id, "Expected first photo to have a non-nil id")
                XCTAssertNotNil(firstPhoto.owner, "Expected first photo to have a non-nil owner")
                XCTAssertNotNil(firstPhoto.title, "Expected first photo to have a non-nil title")
            }
            
            for photo in photos {
                XCTAssertFalse(photo.id.isEmpty, "Expected photo id to be non-empty")
                XCTAssertFalse(photo.owner.isEmpty, "Expected photo owner to be non-empty")
            }
        } catch {
            XCTFail("Expected successful photo fetch but recieved error: \(error)")
        }
    }
    
    func testFetchPhotosNetworkError() async throws {
        // given
        mockSession.mockedData = Data()
        
        // when
        let networkError = URLError(.notConnectedToInternet)
        mockSession.mockedError = networkError
        
        
        
        do {
            // then
            _ = try await networkService.fetchPhotos(withQuery: "grangemouth", page: 2)
            XCTFail("Expected network error to be thrown")
        } catch {
            // check the error using pattern matching
            if let urlError = error as? URLError {
                XCTAssertEqual(urlError.code, .notConnectedToInternet, "Expected not connected to internet error code")
            } else {
                XCTFail("Expected URLError but received a different kind of error")
            }
        }
    }
    
    func testFetchNsidForUsername() async throws {
        // given
        mockSession.mockedData = TestStubs.nsidLookupResponse.data(using: .utf8)!
        
        do {
            // when
            let nsidResponse = try await networkService.fetchNsid(forUsername: "flickr")
            
            // then
            XCTAssertNotNil(nsidResponse, "Expected nsid response to not be nil")
            XCTAssertTrue(!nsidResponse.isEmpty, "Expected a non empty string")
            
        } catch {
            XCTFail("Expected successful user nsid fetch but recieved error: \(error)")
        }
    }
    
    func testFetchNsidForUsernameError() async throws {
        // given
        mockSession.mockedData = Data()
        mockSession.mockedError = NetworkError.userNotFound
        
        do {
            // when
            _ = try await networkService.fetchNsid(forUsername: "daniel")
            XCTFail("Expected userNotFound error")
        } catch {
            
            if let networkError = error as? NetworkError {
                // then
                XCTAssertEqual(networkError, .userNotFound, "Expected user not found error")
            } else {
                XCTFail("Expected userNotFound error but recieved a different kind of error")
            }
        }
    }
    
    func testFetchPhotosByTagSuccess() async throws {
        // given
        mockSession.mockedData = TestStubs.fetchPhotosSuccessResponse.data(using: .utf8)
        
        // when
        let photos = try await networkService.fetchPhotos(withQuery: "falkirk", page: 1)
        
        // then
        XCTAssertNotNil(photos, "Expected photos to not be nil")
        XCTAssertFalse(photos.isEmpty, "Expected at least one photo in the response")
        XCTAssertEqual(photos.first?.tags?.contains("falkirk"), true, "expected to find falkirk in photo tags")
    }
    
    func testFetchPhotosByTagError() async throws {
        // given
        mockSession.mockedData = Data()
        mockSession.mockedError = NetworkError.failedToFetchTags
        
        do {
            // when
            _ = try await networkService.fetchPhotos(withQuery: "falkirk", page: 1)
            XCTFail("Expected failed to fetch tags error")
        } catch {
            
            if let networkError = error as? NetworkError {
                // then
                XCTAssertEqual(networkError, .failedToFetchTags, "Expected failed to fetch tags error")
            } else {
                XCTFail("Expected failed to fetch tags error but recieved a different kind of error")
            }
        }
    }
    
    func testFetchPhotosByUsernameSuccess() async throws {
        // given
        let username = "flickr"
        mockSession.mockedData = TestStubs.fetchPhotosByUsernameResponse.data(using: .utf8)
        
        
        do {
            // when
            let photos = try await networkService.fetchPhotos(withQuery: username, page: 1)
            
            // then
            XCTAssertNotNil(photos, "Expected photos to not be nil")
            XCTAssertFalse(photos.isEmpty, "Expected at least one photo in the response")
            XCTAssertEqual(photos.first?.owner, "66956608@N06", "Expected the photo's owner to match the NSID for the username")
        } catch {
            XCTFail("Expected photos response but recieved: \(error)")
        }
        
    }
    
    func testFetchPhotosByUsernameNotFound() async throws {
        // given
        let username = "@daniel"
        mockSession.mockedData = TestStubs.nsidNotFoundResponse.data(using: .utf8)
        
        do {
            // when
            _ = try await networkService.fetchPhotos(withQuery: username, page: 1)
            XCTFail("expected user not found error to be thrown")
        } catch {
            // then
            if let networkError = error as? NetworkError, networkError == .userNotFound {
                XCTAssertTrue(true, "correctly threw a userNotFound error")
            } else {
                XCTFail("Expected userNotFound error but received a different error")
            }
        }
    }
    
    func testFetchUserInfoSuccess() async throws {
        // given
        let userId = "66956608@N06"
        mockSession.mockedDataForUserInfo = TestStubs.fetchUserInfoSuccessResponse.data(using: .utf8)
        
        do {
            // When
            let userInfo = try await networkService.fetchUserInfo(forUserId: userId)
            
            // Then
            XCTAssertNotNil(userInfo, "Expected userInfo to not be nil")
            XCTAssertEqual(userInfo.id, "66956608@N06", "Expected the user ID to match the fetched user info ID")
            XCTAssertEqual(userInfo.nsid, "66956608@N06", "Expected NSID to match")
            XCTAssertEqual(userInfo.username._content, "Flickr", "Expected username to match")
            XCTAssertEqual(userInfo.iconServer, "3741", "Expected icon server to match")
            XCTAssertEqual(userInfo.iconFarm, 4, "Expected icon farm to match")
            XCTAssertEqual(userInfo.photos?.count._content, 1040, "Expected photo count to match")
            
        } catch {
            XCTFail("Expected successful user info fetch but received error: \(error)")
        }
    }
    
    func testFetchProfileInfoSuccess() async throws {
        // given
        let userId = "66956608@N06"
        mockSession.mockedDataForProfileInfo = TestStubs.fetchProfileInfoSuccessResponse.data(using: .utf8)
        
        do {
            // When
            let profileInfo = try await networkService.fetchProfileInfo(forUserId: userId)
            
            // Then
            XCTAssertNotNil(profileInfo, "Expected profileInfo to not be nil")
            XCTAssertEqual(profileInfo.occupation, "", "Expected occupation to match")
            XCTAssertEqual(profileInfo.city, "", "Expected city to match")
            XCTAssertEqual(profileInfo.firstName, "Flickr", "Expected first name to match")
            XCTAssertEqual(profileInfo.lastName, "", "Expected last name to match")
            
        } catch {
            XCTFail("Expected successful profile info fetch but received error: \(error)")
        }
    }
    
    func testFetchPhotosForUserSuccess() async throws {
        // given
        let userId = "66956608@N06"
        let currentPhotoId = "53322715959"
        let perPage = 10
        let page = 1
        
        mockSession.mockedData = TestStubs.fetchPhotosForUserSuccessResponse.data(using: .utf8)
        
        do {
            // then
            let userPhotos = try await networkService.fetchPhotosForUser(userId: userId, currentPhotoId: currentPhotoId, perPage: perPage, page: page)
            
            // when
            XCTAssertNotNil(userPhotos, "Expected user photos to not be nil")
            XCTAssertTrue(!userPhotos.isEmpty, "Expected at least one photo in the response")
            XCTAssertNil(userPhotos.first(where: { $0.id == currentPhotoId }), "Expected the current photo ID to be excluded from the response")
            
        } catch {
            XCTFail("Expected successful fetching of photos for user but received error: \(error)")
        }
    }
    
    @MainActor
    func testConstructPhotoUrl() {
        // given
        let photo = Photo(id: "53322715959", owner: "66956608@N06", title: "Photo title", secret: "2233ab274b", server: "65535", farm: 66, tags: "", description: NestedStringContentWrapper(_content: ""), license: "", dateupload: "", ownername: "", iconserver: "")
        
        // when
        let photoUrl = networkService.constructPhotoUrl(photo: photo)
        
        // then
        XCTAssertNotNil(photoUrl, "Expected constructed URL to not be nil")
        XCTAssertEqual(photoUrl?.absoluteString, "https://live.staticflickr.com/65535/53322715959_2233ab274b.jpg", "Expected URL to be constructed correctly")
    }
    
    func testConstructGalleryThumbnailUrl() {
        // given
        let gallery = Gallery(
            id: "63055753-72157720083775277",
            galleryId: "72157720083775277",
            primaryPhotoId: "50607475588",
            photoCount: 100,
            viewCount: 1000,
            title: NestedStringContentWrapper(_content: "Gallery Title"),
            description: NestedStringContentWrapper(_content: "Gallery Description"),
            primaryPhotoServer: "65535",
            primaryPhotoFarm: 66,
            primaryPhotoSecret: "2304f903ea"
        )
        
        
        // when
        let thumbnailUrl = networkService.constructGalleryThumbnailUrl(gallery: gallery)
        
        // then
        XCTAssertNotNil(thumbnailUrl, "Expected constructed URL to not be nil")
        XCTAssertEqual(thumbnailUrl?.absoluteString, "https://live.staticflickr.com/65535/50607475588_2304f903ea.jpg", "Expected URL to be constructed correctly")
    }
    
    func testFetchCompleteUserInfoSuccess() async throws {
        // given
        let userId = "66956608@N06"
        
        mockSession.mockedDataForUserInfo = TestStubs.fetchUserInfoSuccessResponse.data(using: .utf8)
        mockSession.mockedDataForProfileInfo = TestStubs.fetchProfileInfoSuccessResponse.data(using: .utf8)
        
        
        do {
            // when
            let completeUserInfo = try await networkService.fetchCompleteUserInfo(forUserId: userId)
            
            // then
            XCTAssertNotNil(completeUserInfo, "Expected complete user info to not be nil")
            XCTAssertEqual(completeUserInfo.userInfo.id, userId, "Expected fetched user info ID to match the given user ID")
        } catch {
            XCTFail("Expected complete user info responsse but recieved: \(error)")
        }
        
    }
    
    func testFetchCompleteUserInfoUserFailure() async throws {
        // given
        let userId = "-++_invalid__££id"
        mockSession.mockedError = NetworkError.failedToFetchUserInfo
        
        // when
        do {
            _ = try await networkService.fetchCompleteUserInfo(forUserId: userId)
            XCTFail("Expected failure when fetching complete user info")
        } catch let error as NetworkError {
            // then
            XCTAssertEqual(error, .failedToFetchUserInfo, "Expected failed to fetch user info error")
        }
    }
    
    func testFetchUserGalleriesSuccess() async throws {
        // given
        let userId = "validUserId"
        mockSession.mockedData = TestStubs.fetchUserGalleriesSuccessResponse.data(using: .utf8)
        
        do {
            // when
            let galleries = try await networkService.fetchUserGalleries(userId: userId, page: 1)
            
            // then
            XCTAssertNotNil(galleries, "Expected galleries to not be nil")
            XCTAssertEqual(galleries.count, 3, "Expected 3 galleries in the response")
            
            if let firstGallery = galleries.first {
                XCTAssertEqual(firstGallery.id, "63055753-72157720083775277", "Expected correct gallery ID")
                XCTAssertEqual(firstGallery.galleryId, "72157720083775277", "Expected correct gallery ID")
                XCTAssertEqual(firstGallery.primaryPhotoId, "50607475588", "Expected correct primary photo ID")
                XCTAssertEqual(firstGallery.primaryPhotoServer, "65535", "Expected correct primary photo server")
                XCTAssertEqual(firstGallery.primaryPhotoFarm, 66, "Expected correct primary photo farm")
                XCTAssertEqual(firstGallery.primaryPhotoSecret, "2304f903ea", "Expected correct primary photo secret")
            }
            
        } catch {
            XCTFail("Expected user galleries response but recieved \(error)")
        }
        
    }
    
    func testFetchUserGalleriesNoGalleries() async throws {
        // given
        let userId = "61969044@N07"
        mockSession.mockedData = TestStubs.fetchUserGalleriesNoGalleriesResponse.data(using: .utf8)
        
        // when
        let galleries = try await networkService.fetchUserGalleries(userId: userId, page: 1)
        
        // then
        XCTAssertTrue(galleries.isEmpty, "Expected no galleries in the response for a user with no galleries")
    }
    
    func testFetchUserGalleriesNetworkError() async throws {
        // given
        let userId = "someUserId"
        mockSession.mockedError = NetworkError.failedToFetchGalleriesForUser
        
        do {
            // when
            _ = try await networkService.fetchUserGalleries(userId: userId, page: 1)
            XCTFail("Expected failed to fetch galleries for user error to be thrown")
        } catch let error as NetworkError {
            // then
            XCTAssertEqual(error, .failedToFetchGalleriesForUser, "Expected failed to fetch galleries for user error")
        }
    }
    
    func testFetchGalleryPhotosSuccess() async throws {
        // given
        let galleryId = "72157622763060009"
        let userId = "8070463@N03"
        
        mockSession.mockedData = TestStubs.fetchGalleryPhotosSuccessResponse.data(using: .utf8)
        
        do {
            // when
            let galleryPhotos = try await networkService.fetchGalleryPhotos(userId: userId, galleryId: galleryId, perPage: 10, page: 1)
            
            // then
            XCTAssertNotNil(galleryPhotos, "Expected gallery photos to not be nil")
            XCTAssertEqual(galleryPhotos.count, 3, "Expected photo count to match the mocked response")
            
        } catch {
            XCTFail("Expected successful gallery photos fetch but received error: \(error)")
        }
    }
    
    func testFetchGalleryPhotosNetworkError() async throws {
        // given
        let galleryId = "72157622763060009"
        let userId = "8070463@N03"
        
        mockSession.mockedError = NetworkError.failedToFetchPhotosFromGallery
        
        do {
            // When
            _ = try await networkService.fetchGalleryPhotos(userId: userId, galleryId: galleryId, perPage: 3, page: 1)
            XCTFail("Expected failed to fetch galleries for user error to be thrown")
        } catch let error as NetworkError {
            // Then
            XCTAssertEqual(error, .failedToFetchPhotosFromGallery, "Expected failed to fetch galleries for user error")
        }
    }   
}
