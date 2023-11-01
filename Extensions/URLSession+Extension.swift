//
//  URLSession+Extension.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import Foundation

// this extension allows for dependency injection inside the network service so that a mock URLSession can be passed in testing
extension URLSession: URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        let request = URLRequest(url: url)
        return try await self.data(for: request)
    }
}
