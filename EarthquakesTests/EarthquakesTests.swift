//
//  EarthquakesTests.swift
//  EarthquakesTests
//
//  Created by varunbhalla19 on 06/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import XCTest
@testable import Earthquakes

// @testable -> give the unit tests access to the app’s internal functions and types.

final class EarthquakesTests: XCTestCase {

    func testGeoJSONDecoderDecodesQuake() throws {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        
        let testQuake = try decoder.decode(Quake.self, from: testData1)
        
        XCTAssertEqual(testQuake.code, "73649170")
        
        let expectedSeconds = TimeInterval(1636129710550) / 1000
        let decodedSeconds = testQuake.time.timeIntervalSince1970
        
        XCTAssertEqual(expectedSeconds, decodedSeconds, accuracy: 0.00001)
        
    }

    func testGeoJSONDecoderDecodesGeoJSON() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        let decoded = try decoder.decode(GeoJSON.self, from: testQuakesData)

        XCTAssertEqual(decoded.quakes.count, 6)
        XCTAssertEqual(decoded.quakes[0].code, "73649170")

        let expectedSeconds = TimeInterval(1636129710550) / 1000
        let decodedSeconds = decoded.quakes[0].time.timeIntervalSince1970
        XCTAssertEqual(expectedSeconds, decodedSeconds, accuracy: 0.00001)
    }

    func testQuakeDetailsDecoder() throws {
        let decoded = try JSONDecoder().decode(QuakeLocation.self, from: testDetail)
        XCTAssertEqual(decoded.latitude, 19.2189998626709, accuracy: 0.00000000001)
    }
    
    func testClientDoesFetchEarthquakeData() async throws {
        let downloader = TestDownloader()
        let quakeClient = QuakeClient(downloader: downloader)
        let quakes = try await quakeClient.quakes
        XCTAssertEqual(quakes.count, 6)
    }
    
}
