//
//  QuakeDetail.swift
//  Earthquakes-iOS
//
//  Created by varunbhalla19 on 21/11/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI

struct QuakeDetail: View {
    
    let quake: Quake
    @EnvironmentObject var provider: QuakesProvider
    
    @State var location: QuakeLocation? = nil
    
    var body: some View {
        VStack {
            if let location = self.location {
                QuakeDetailMap(location: location, tintColor: quake.color)
                    .ignoresSafeArea(.container)
            }
            QuakeMagnitude(quake: quake)
            Text(quake.place)
                .font(.title3)
                .bold()
            Text("\(quake.time.formatted())")
                .foregroundStyle(Color.secondary)
            
            if let location = self.location {
                Text("Latitude: \(location.latitude.formatted(.number.precision(.fractionLength(3))))")
                Text("Longitude: \(location.longitude.formatted(.number.precision(.fractionLength(3))))")
            }
        }.task {
            if location == nil {
                if let quakeLocation = quake.location {
                    self.location = quakeLocation
                } else {
                    let result = try? await provider.quakeLocation(for: quake)
                    self.location = result
                }
            }
        }
    }
}

struct QuakeDetail_Previews: PreviewProvider {
    static var previews: some View {
        QuakeDetail(quake: Quake.preview)
    }
}
