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
    var mockedResponse: URLResponse?
    
    func dataTask(with request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockedError {
            throw error
        }
        
        guard let data = mockedData else {
            throw NSError(domain: "No mocked data provided", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mocked data provided"])
        }
        
        let response = mockedResponse ?? HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        
        return (data, response)
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        // throw error if mocked error is passed
        if let error = mockedError {
            throw error
        }
        
        // throw error if mockedData is not passed
        guard let data = mockedData else {
            throw NSError(domain: "No data", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mocked data provided"])
        }
        
        return (data, HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }
}

