//
//  TestDownloader.swift
//  Earthquakes-iOS
//
//  Created by varunbhalla19 on 06/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation

class TestDownloader: HTTPDataDownloader {

    func httpData(from url: URL) async throws -> Data {        
        try await Task.sleep(nanoseconds: UInt64.random(in: 100_000_000...500_000_000))
        return testQuakesData
    }
    
    
    
    
}
