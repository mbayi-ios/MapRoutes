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

    //
    @Published var region: MKCoordinateRegion!

    @Published var permissionDenied = false

    //Map type
    @Published var mapType: MKMapType = .standard

    // search text
    @Published var searchText = ""

    // searched places
    @Published var places: [Place] = []
    
    // updating map type.. 
    func updateMapType() {
        if mapType == .standard {
            mapType = .hybrid
            mapView.mapType = mapType
        } else {
            mapType = .standard
            mapView.mapType = mapType
        }
    }

    // focus Location
    func focusLocation() {
        guard let _ = region else { return }

        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }

    // search places...
    func searchQuery() {
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText

        // fetch...
        MKLocalSearch(request: request).start { (response, _) in
            guard let result = response else { return }

            self.places = result.mapItems.compactMap({(item) -> Place? in
                return Place(place: item.placemark)
            })
        }
    }

    // Pick Search Result...
    func selectPlace(place: Place) {
        searchText = ""
        guard let coordinate = place.place.location?.coordinate else { return }
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.place.name ?? "No Name"

        // removing all old ones
        mapView.removeAnnotations(mapView.annotations)

        mapView.addAnnotation(pointAnnotation)

        // Moving map to that location
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }


    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // checking permissions ...

        switch manager.authorizationStatus {
        case .denied:
            // alert...
            permissionDenied.toggle()
        case .notDetermined:
            // requesting...
            manager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse:
            manager.requestLocation()
        default:
            ()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

     // getting user region
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return}
        self.region  =  MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)


        // updating map
        self.mapView.setRegion(self.region, animated: true)

        // smooth animations
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
}
