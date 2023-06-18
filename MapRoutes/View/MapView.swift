
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

    }


}
