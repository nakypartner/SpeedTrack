import SwiftUI
import MapKit

struct TripDetailView: View {
    let trip: Trip

    @State private var region: MKCoordinateRegion

    init(trip: Trip) {
        self.trip = trip
        if let first = trip.points.first {
            _region = State(initialValue: MKCoordinateRegion(
                center: first.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ))
        } else {
            _region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 50.0755, longitude: 14.4378),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ))
        }
    }

    /// Zjednodušeně zobrazujeme jen start a cíl trasy (plná čára trasy
    /// vyžaduje MKPolyline přes UIViewRepresentable - viz README, sekce "Další kroky").
    private var endpoints: [TrackPoint] {
        guard let first = trip.points.first else { return [] }
        guard let last = trip.points.last, last.id != first.id else { return [first] }
        return [first, last]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Map(coordinateRegion: $region, annotationItems: endpoints) { point in
                    MapMarker(coordinate: point.coordinate)
                }
                .frame(height: 280)
                .cornerRadius(16)
                .padding(.horizontal)

                VStack(spacing: 12) {
                    statRow("Max rychlost", "\(Int(trip.maxSpeedKmh)) km/h")
                    statRow("Průměrná rychlost", String(format: "%.0f km/h", trip.averageSpeedKmh))
                    statRow("Vzdálenost", String(format: "%.2f km", trip.distanceMeters / 1000))
                    statRow("Doba jízdy", formattedDuration(trip.durationSeconds))
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Detail jízdy")
    }

    private func statRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }

    private func formattedDuration(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d min", minutes, secs)
    }
}
