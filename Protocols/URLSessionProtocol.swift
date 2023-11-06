//
//  URLSessionProtocol.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 31/10/2023.
//

import Foundation

// protocol that both URLSession and MockURLSession will adhere to
protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
    func dataTask(with request: URLRequest) async throws -> (Data, URLResponse)
}
