import SwiftUI

struct HistoryView: View {
    @ObservedObject var tripStore: TripStore

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        f.locale = Locale(identifier: "cs_CZ")
        return f
    }()

    var body: some View {
        NavigationView {
            Group {
                if tripStore.trips.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "map")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        Text("Zatím žádné jízdy")
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(tripStore.trips) { trip in
                            NavigationLink(destination: TripDetailView(trip: trip)) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(dateFormatter.string(from: trip.startDate))
                                        .font(.subheadline.bold())
                                    HStack {
                                        Label("\(Int(trip.maxSpeedKmh)) km/h", systemImage: "speedometer")
                                        Spacer()
                                        Label(String(format: "%.1f km", trip.distanceMeters / 1000), systemImage: "arrow.triangle.swap")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete(perform: tripStore.delete)
                    }
                }
            }
            .navigationTitle("Historie tras")
        }
    }
}
