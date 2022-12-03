//
//  QuakeClient.swift
//  Earthquakes-iOS
//
//  Created by varunbhalla19 on 06/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation


actor QuakeClient {
    
    let cache: NSCache<NSString, CacheEntryObject> = .init()
    
    private let feedURL = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson")!
    
    
    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .millisecondsSince1970
        return aDecoder
    }()
    
    private let downloader: any HTTPDataDownloader
    
    init(downloader: any HTTPDataDownloader = URLSession.shared) {
        self.downloader = downloader
    }

    
    var quakes: [Quake] {
        get async throws {
            let data = try await downloader.httpData(from: feedURL)
            let response = try decoder.decode(GeoJSON.self, from: data)
            var updatedResponse = response.quakes
            if let afterOneHr = updatedResponse.firstIndex(where: { quake in
                quake.time.timeIntervalSinceNow > 3600
            }) {
                let indexRange = updatedResponse.startIndex..<afterOneHr
                
                try await withThrowingTaskGroup(of: (Int, QuakeLocation).self) { taskGroup in
                    for i in indexRange {
                        taskGroup.addTask {
                            let location = try await self.quakeLocation(from: response.quakes[i].detail)
                            return (i, location)
                        }
                    }
                    while let result = await taskGroup.nextResult() {
                        switch result {
                        case .success(let success):
                            updatedResponse[success.0].location = success.1
                        case .failure(let failure):
                            throw failure
                        }
                    }
                }
                
            }
            return updatedResponse
        }
    }
    
    func quakeLocation(from url: URL) async throws -> QuakeLocation {
        
        if let entry = cache[url] {
            switch entry {
                case .inProgress(let task):
                    return try await task.value
                case .location(let quakeLocation):
                    return quakeLocation
            }
        }
        
        let task: Task<QuakeLocation, Error> = Task {
            let result = try await downloader.httpData(from: url)
            let location = try decoder.decode(QuakeLocation.self, from: result)
            return location
        }
        
        cache[url] = .inProgress(task)
        
        do {
            let location = try await task.value
            cache[url] = .location(location)
            return location
        } catch {
            cache[url] = nil
            throw error
        }
                
    }
    
}
