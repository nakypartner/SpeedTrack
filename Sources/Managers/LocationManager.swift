import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()

    @Published var currentSpeedKmh: Double = 0
    @Published var maxSpeedKmh: Double = 0
    @Published var isTracking = false
    @Published var currentPoints: [TrackPoint] = []
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var lastKnownLocation: CLLocation?

    private var lastLocation: CLLocation?
    private var distanceMeters: Double = 0
    private var startDate: Date?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.activityType = .automotiveNavigation
        manager.pausesLocationUpdatesAutomatically = false
        manager.startUpdatingLocation()
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func startTracking() {
        currentPoints = []
        distanceMeters = 0
        maxSpeedKmh = 0
        lastLocation = nil
        startDate = Date()
        isTracking = true
    }

    /// Vrátí dokončenou jízdu, nebo nil, pokud se nezaznamenal žádný bod.
    func stopTracking() -> Trip? {
        isTracking = false
        guard let start = startDate, !currentPoints.isEmpty else { return nil }
        let trip = Trip(
            startDate: start,
            endDate: Date(),
            points: currentPoints,
            maxSpeedKmh: maxSpeedKmh,
            distanceMeters: distanceMeters
        )
        return trip
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastKnownLocation = location

        // CoreLocation vrací rychlost v m/s, záporná hodnota = neznámá rychlost
        let speedMps = max(location.speed, 0)
        let speedKmh = speedMps * 3.6
        currentSpeedKmh = speedKmh
        if speedKmh > maxSpeedKmh {
            maxSpeedKmh = speedKmh
        }

        if isTracking {
            if let last = lastLocation {
                distanceMeters += location.distance(from: last)
            }
            lastLocation = location

            let point = TrackPoint(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                speed: speedMps,
                timestamp: location.timestamp
            )
            currentPoints.append(point)
        }
    }
}
