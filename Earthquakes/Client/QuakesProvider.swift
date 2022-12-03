//
//  QuakesProvider.swift
//  Earthquakes-iOS
//
//  Created by varunbhalla19 on 06/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation

@MainActor
class QuakesProvider: ObservableObject {
    
    @Published var quakes: [Quake] = .init()
    
    let quakeClient: QuakeClient
    
    init(quakeClient: QuakeClient = .init()) {
        self.quakeClient = quakeClient
    }
    
    func fetchQuakes() async throws {
        let result = try await quakeClient.quakes
        self.quakes = result
    }
    
    func deleteQuakes(at offSets: IndexSet) {
        quakes.remove(atOffsets: offSets)
    }
    
    func quakeLocation(for quake: Quake) async throws -> QuakeLocation {
        return try await quakeClient.quakeLocation(from: quake.detail)
    }
    
}
