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
        networkService = NetworkService(session: MockURLSession())
    }
    
    override func tearDown() {
        mockSession = nil
        networkService = nil
        super.tearDown()
    }
    
    func testFetchPhotosSuccess() async throws {
        // define the mock session
        
        
        // set the mocked data to the stub (based on flickr response format)
        mockSession.mockedData = TestStubs.fetchPhotosSuccessResponse.data(using: .utf8)
        
        do {
            let photos = try await NetworkService.shared.fetchPhotos(withQuery: "grangemouth", page: 2)
            
            // test response structure
            XCTAssertNotNil(photos, "Expected photos to not be nil")
            XCTAssert(photos.count > 0, "Expected at least one photo in the response")
            
            // check first photo structure
            if let firstPhoto = photos.first {
                XCTAssertNotNil(firstPhoto.id, "Expected first photo to have a non-nil id")
                XCTAssertNotNil(firstPhoto.owner, "Expected first photo to have a non-nil owner")
                XCTAssertNotNil(firstPhoto.title, "Expected first photo to have a non-nil title")
            }
            
            // test non-empty values
            for photo in photos {
                XCTAssertFalse(photo.id.isEmpty, "Expected photo id to be non-empty")
                XCTAssertFalse(photo.owner.isEmpty, "Expected photo owner to be non-empty")
            }
        } catch {
            XCTFail("Expected successful photo fetch but recieved error: \(error)")
        }
    }
    
    func testFetchPhotosNetworkError() async throws {
        // simulate network error
        let networkError = URLError(.notConnectedToInternet)
        
        mockSession.mockedError = networkError
        
        
        do {
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
}
