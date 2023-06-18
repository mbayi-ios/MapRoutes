
import SwiftUI
import MapKit
import UIKit


struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView

    @EnvironmentObject var mapData: MapViewModel

    func makeUIView(context: Context) -> MKMapView {
        let view  = mapData.mapView

        view.showsUserLocation = true
        view.delegate = context.coordinator
        return view
    }

    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator()
    }


    func updateUIView(_ uiView: MKMapView, context: Context) {

    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // custom Pins

            // Excluding User Blue Circle

            if annotation.isKind(of: MKUserLocation.self) { return nil}
            else {
                let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
                pinAnnotation.tintColor = .red
                pinAnnotation.animatesDrop = true
                pinAnnotation.canShowCallout = true

                return pinAnnotation
            }
        }
    }


}
