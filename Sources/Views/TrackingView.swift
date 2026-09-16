import SwiftUI
import MapKit

struct TrackingView: View {
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var tripStore: TripStore

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 50.0755, longitude: 14.4378),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        VStack(spacing: 20) {
            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
                .frame(height: 280)
                .cornerRadius(16)
                .padding(.horizontal)

            VStack(spacing: 4) {
                Text("\(Int(locationManager.currentSpeedKmh))")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .monospacedDigit()
                Text("km/h")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 40) {
                statBlock(title: "Max rychlost", value: "\(Int(locationManager.maxSpeedKmh)) km/h")
                statBlock(title: "Body trasy", value: "\(locationManager.currentPoints.count)")
            }

            Button(action: toggleTracking) {
                Text(locationManager.isTracking ? "Ukončit jízdu" : "Začít jízdu")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(locationManager.isTracking ? Color.red : Color.green)
                    .cornerRadius(14)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
    }

    private func statBlock(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3.bold())
        }
    }

    private func toggleTracking() {
        if locationManager.isTracking {
            if let trip = locationManager.stopTracking() {
                tripStore.add(trip)
            }
        } else {
            locationManager.startTracking()
        }
    }
}
