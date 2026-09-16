import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var tripStore = TripStore()

    var body: some View {
        TabView {
            TrackingView(locationManager: locationManager, tripStore: tripStore)
                .tabItem {
                    Label("Jízda", systemImage: "speedometer")
                }
            HistoryView(tripStore: tripStore)
                .tabItem {
                    Label("Historie", systemImage: "map")
                }
        }
        .onAppear {
            locationManager.requestPermission()
        }
    }
}
