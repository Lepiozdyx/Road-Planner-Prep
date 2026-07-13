import SwiftUI

struct RouteStopCardView: View {
    let stop: Stop
    let tripId: UUID
    @Environment(AppDetails.self) private var store
    @State private var showAddPlace = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(stop.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                    Text("\(stop.distanceFromStart) km from start")
                        .font(.system(size: 14))
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }
                Spacer()
                Button {
                    showAddPlace = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(AppTheme.Colors.accentPrimary)
                        .frame(width: AppTheme.Size.touchTargetMin,
                               height: AppTheme.Size.touchTargetMin)
                }
            }

            if !stop.places.isEmpty {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(stop.places) { place in
                            Text(place.name)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(AppTheme.Colors.textPrimary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(AppTheme.Colors.accentPrimary.opacity(0.8))
                                .clipShape(Capsule())
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .padding(16)
        .background(AppTheme.Colors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
        .sheet(isPresented: $showAddPlace) {
            AddPlaceView(stopId: stop.id, tripId: tripId)
        }
    }
}
