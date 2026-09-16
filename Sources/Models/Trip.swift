import Foundation
import CoreLocation

struct TrackPoint: Codable, Identifiable {
    var id = UUID()
    let latitude: Double
    let longitude: Double
    let speed: Double // m/s
    let timestamp: Date

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct Trip: Codable, Identifiable {
    var id = UUID()
    var startDate: Date
    var endDate: Date
    var points: [TrackPoint]
    var maxSpeedKmh: Double
    var distanceMeters: Double

    var durationSeconds: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }

    var averageSpeedKmh: Double {
        let hours = durationSeconds / 3600
        guard hours > 0 else { return 0 }
        return (distanceMeters / 1000) / hours
    }
}
