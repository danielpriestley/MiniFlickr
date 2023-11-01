//
//  NetworkServiceTests.swift
//  MiniFlickrTests
//
//  Created by Daniel Priestley on 31/10/2023.
//

import XCTest
@testable import MiniFlickr

final class NetworkServiceTests: XCTestCase {
    
    // setUp and tearDown allow for NetworkService to be set and reset between tests
    override func setUp() {
        super.setUp()
        NetworkService.shared = NetworkService(session: MockURLSession())
    }
    
    override func tearDown() {
        NetworkService.shared = NetworkService(session: MockURLSession())
        super.tearDown()
    }

    func testFetchPhotos() async throws {
        // define the mock session
        let mockSession = MockURLSession()
        
        // set the mocked data to the stub (based on flickr response format)
        mockSession.mockedData = TestStubs.fetchPhotosResponse.data(using: .utf8)
        
        // Set the session dependency as the mock URL session
        NetworkService.shared = NetworkService(session: mockSession)
        
        do {
            let photos = try await NetworkService.shared.fetchPhotos(withQuery: "new york", page: 1)
            
            XCTAssertEqual(photos.count, 3, "Expected 3 photos but got \(photos.count)")
            XCTAssertEqual(photos[0].id, "53295906315", "Unexpected photo ID for the first photo")
            XCTAssertEqual(photos[0].title, "The Wall", "Unexpected title for the first photo")
            
        } catch {
            XCTFail("Error fetching photos: \(error)")
        }
    }

}
