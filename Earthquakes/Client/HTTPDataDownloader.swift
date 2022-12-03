//
//  HTTPDataDownloader.swift
//  Earthquakes-iOS
//
//  Created by varunbhalla19 on 06/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation

let validStatus = 200...299

protocol HTTPDataDownloader {
    func httpData(from url:URL) async throws -> Data
}

extension URLSession: HTTPDataDownloader {
    func httpData(from url: URL) async throws -> Data {
        guard let (data, response) = try await self.data(from: url) as? (Data, HTTPURLResponse),
              validStatus.contains(response.statusCode) else {
            throw QuakeError.missingData
        }
        return data
    }
}
