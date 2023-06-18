import SwiftUI
import CoreLocation

struct Home: View {
    @StateObject var mapData = MapViewModel()
    @State var locationManager = CLLocationManager()

    var body: some View {
        ZStack {
            MapView()
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
        }
        .onAppear(perform: {
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
        })
        .alert(isPresented: $mapData.permissionDenied, content: {
            Alert(title: Text("Permission Denied"), message: Text("Please Enable Permission in App Settings"), dismissButton: .default(Text("Goto Settings"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
