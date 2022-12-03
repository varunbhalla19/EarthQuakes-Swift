//
//  QuakeDetailMap.swift
//  Earthquakes-iOS
//
//  Created by varunbhalla19 on 21/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI
import MapKit

struct QuakeDetailMap: View {
    
    let location: QuakeLocation
    let tintColor: Color
    private var place: QuakePlace

    init(location: QuakeLocation, tintColor: Color) {
        self.location = location
        self.tintColor = tintColor
        self.place = QuakePlace(location: location)
    }

    
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [place]) { place in
                    MapMarker(coordinate: place.location, tint: tintColor)
            }
            .onAppear {
                withAnimation {
                    region.center = place.location
                    region.span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                }
            }
        
    }
}

struct QuakeDetailMap_Previews: PreviewProvider {
    static var previews: some View {
        QuakeDetailMap(location: .init(latitude: 155, longitude: 43), tintColor: .cyan)
    }
}



struct QuakePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    
    init(id: UUID = UUID(), location: QuakeLocation) {
        self.id = id
        self.location = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
}
