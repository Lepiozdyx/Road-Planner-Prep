import SwiftUI

struct StatisticsView: View {
    @Environment(AppDetails.self) private var store

    private var totalDistance: Int {
        store.trips.reduce(0) { $0 + $1.distanceKm }
    }

    private var sortedTrips: [Trip] {
        store.trips.sorted { $0.distanceKm > $1.distanceKm }
    }

    private var monthlyEntries: [MonthlyDistanceEntry] {
        let _ = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        var grouped: [String: Int] = [:]
        var order: [String] = []

        let sorted = store.trips.sorted { $0.createdAt < $1.createdAt }
        for trip in sorted {
            let month = formatter.string(from: trip.createdAt)
            if grouped[month] == nil { order.append(month) }
            grouped[month, default: 0] += trip.distanceKm
        }

        let maxDist = grouped.values.max() ?? 0
        return order.map { month in
            MonthlyDistanceEntry(
                month: month,
                distance: grouped[month] ?? 0,
                isHighlighted: grouped[month] == maxDist
            )
        }
    }

    var body: some View {
        AppShell {
            VStack(spacing: 0) {
                titleBar

                ScrollView {
                    VStack(spacing: AppTheme.Spacing.cardGap) {
                        totalDistanceCard

                        if !monthlyEntries.isEmpty {
                            MonthlyBarChartView(entries: monthlyEntries)
                        }

                        if !sortedTrips.isEmpty {
                            topTripsSection
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, AppTheme.Size.tabBarHeight, for: .scrollContent)
            }
        }
    }

    private var titleBar: some View {
        HStack {
            Text("Statistics")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
        .frame(height: AppTheme.Size.topBarHeight)
    }

    private var totalDistanceCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Total Distance Traveled")
                .font(.system(size: 14))
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .center)

            Text(formattedDistance(totalDistance))
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(AppTheme.Colors.accentSecondary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(16)
        .background(AppTheme.Colors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
    }

    private var topTripsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "trophy.fill")
                    .foregroundStyle(AppTheme.Colors.accentSecondary)
                Text("Top Trips")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
            }

            ForEach(Array(sortedTrips.prefix(5).enumerated()), id: \.element.id) { index, trip in
                RankingRowView(rank: index + 1,
                               title: trip.title,
                               distanceKm: trip.distanceKm)
            }
        }
    }

    private func formattedDistance(_ km: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return "\(formatter.string(from: NSNumber(value: km)) ?? "\(km)") km"
    }
}
