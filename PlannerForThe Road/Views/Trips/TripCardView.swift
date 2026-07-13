import SwiftUI

struct TripCardView: View {
    let trip: Trip
    @Environment(AppDetails.self) private var store

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(trip.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(AppTheme.Colors.textTertiary)
            }

            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "location")
                        .font(.system(size: 13))
                        .foregroundStyle(AppTheme.Colors.accentSecondary)
                    Text("\(trip.distanceKm) km")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(AppTheme.Colors.accentSecondary)
                }

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 13))
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                    Text(trip.travelTime)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }
            }

            let progress = trip.packingProgress(in: store)
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Packing Progress")
                        .font(.system(size: 13))
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                    Spacer()
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(AppTheme.Colors.accentSecondary)
                }
                ProgressBarView(progress: progress)
            }
        }
        .padding(16)
        .background(AppTheme.Colors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
        .shadow(color: Color.black.opacity(0.35), radius: 6, y: 2)
    }
}
