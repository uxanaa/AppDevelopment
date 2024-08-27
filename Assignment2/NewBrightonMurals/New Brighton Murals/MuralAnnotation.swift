//
//  MuralAnnotation.swift
//  New Brighton Murals
//
//  Created by Uxanaa Shashitharen on 03/12/2022.
//


import MapKit

// MARK: - define class MuralAnnotation as a class annotated on a map

class MuralAnnotation: NSObject, MKAnnotation {
    
    var id: String
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init?(mural: Mural) {
        guard
            let latString = mural.lat,
            let longString = mural.lon,
            let lat = Double(latString),
            let long = Double(longString)
        else { return nil }
        self.id = mural.id
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.title = mural.title
        self.subtitle = mural.artist
    }
    
}
