//
//  MockURLSession.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    var mockedData: Data?
    var mockedError: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        // throw error if mocked error is passed
        if let error = mockedError {
            throw error
        }
        
        // throw error if mockedData is not passed
        guard let data = mockedData else {
            throw NSError(domain: "No data", code: 0, userInfo: nil)
        }
        
        return (data, HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }
}

