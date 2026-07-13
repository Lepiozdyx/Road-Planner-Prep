import SwiftUI

struct PlacesTabView: View {
    let trip: Trip

    var allPlaces: [(stopName: String, place: Place)] {
        trip.stops.flatMap { stop in
            stop.places.map { (stopName: stop.name, place: $0) }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            if allPlaces.isEmpty {
                emptyState
            } else {
                LazyVStack(spacing: AppTheme.Spacing.itemGap) {
                    ForEach(allPlaces, id: \.place.id) { item in
                        HStack(spacing: 12) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(AppTheme.Colors.accentPrimary)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.place.name)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(AppTheme.Colors.textPrimary)
                                Text(item.stopName)
                                    .font(.system(size: 13))
                                    .foregroundStyle(AppTheme.Colors.textTertiary)
                            }
                            Spacer()
                        }
                        .padding(14)
                        .background(AppTheme.Colors.surfaceElevated)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
                    }
                }
                .padding(.top, 12)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "mappin.slash")
                .font(.system(size: 36))
                .foregroundStyle(AppTheme.Colors.textTertiary)
            Text("No places added yet")
                .font(.system(size: 15))
                .foregroundStyle(AppTheme.Colors.textTertiary)
            Text("Add stops in the Route tab, then tap + to add places to each stop.")
                .font(.system(size: 13))
                .foregroundStyle(AppTheme.Colors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 16)
    }
}

