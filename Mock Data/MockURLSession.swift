//
//  MockURLSession.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    var mockedData: Data?
    var mockedDataForUserInfo: Data?
    var mockedDataForProfileInfo: Data?
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
        
        let data: Data?
        
        switch url.absoluteString {
        case let urlString where urlString.contains("flickr.people.getInfo"):
            data = mockedDataForUserInfo
        case let urlString where urlString.contains("flickr.profile.getProfile"):
            data = mockedDataForProfileInfo
        default:
            data = mockedData
        }
        
        guard let responseData = data else {
            throw NSError(domain: "No data", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mocked data provided for URL \(url.absoluteString)"])
        }
        
        return (responseData, HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }
    
}

