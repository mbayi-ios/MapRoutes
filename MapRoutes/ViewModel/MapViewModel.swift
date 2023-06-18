//
//  MapViewModel.swift
//  MapRoutes
//
//  Created by Amby on 18/06/2023.
//

import Foundation
import MapKit
import CoreLocation
// all map data goes here

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var mapView = MKMapView()

    @Published var region: MKCoordinateRegion!

    @Published var permissionDenied = false

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // checking permissions ...

        switch manager.authorizationStatus {
        case .denied:
            // alert...
            permissionDenied.toggle()
        case .notDetermined:
            // requesting...
            manager.requestWhenInUseAuthorization()
        default:
            ()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
