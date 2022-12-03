/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The app and main window group scene.
*/

import SwiftUI

@main
struct EarthquakesApp: App {
    
    @StateObject var provider = QuakesProvider.init()
    
    var body: some Scene {
        WindowGroup {
            Quakes()
                .environmentObject(provider)
        }
    }
}
