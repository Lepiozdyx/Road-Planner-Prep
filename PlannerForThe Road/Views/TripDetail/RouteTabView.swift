import SwiftUI

struct RouteTabView: View {
    let trip: Trip
    @State private var showAddStop = false

    var body: some View {
        VStack(spacing: 0) {
            if trip.stops.isEmpty {
                emptyState
            } else {
                stopsStack
            }

            PrimaryButton(title: "+ Add Stop") {
                showAddStop = true
            }
            .padding(.top, 16)
            .sheet(isPresented: $showAddStop) {
                AddStopView(tripId: trip.id)
            }
        }
    }

    private var stopsStack: some View {
        VStack(spacing: 0) {
            ForEach(Array(trip.stops.enumerated()), id: \.element.id) { index, stop in
                RouteStopCardView(stop: stop, tripId: trip.id)

                if index < trip.stops.count - 1 {
                    connector
                }
            }
        }
    }

    private var connector: some View {
        Rectangle()
            .fill(AppTheme.Colors.progressTrack)
            .frame(width: 2, height: 24)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "road.lanes")
                .font(.system(size: 36))
                .foregroundStyle(AppTheme.Colors.textTertiary)
            Text("No stops yet")
                .font(.system(size: 15))
                .foregroundStyle(AppTheme.Colors.textTertiary)
        }
        .padding(.vertical, 32)
    }
}
