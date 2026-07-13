import SwiftUI

enum TripTab { case route, places, checklist }

struct TripDetailView: View {
    let trip: Trip
    @Environment(AppDetails.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: TripTab = .route
    @State private var showEdit = false
    @Namespace private var tabNamespace

    private var currentTrip: Trip {
        store.trips.first(where: { $0.id == trip.id }) ?? trip
    }

    var body: some View {
        AppShell {
            VStack(spacing: 0) {
                navBar

                ScrollView {
                    VStack(spacing: 14) {
                        dualMetricCard

                        segmentedTabs

                        switch selectedTab {
                        case .route:
                            RouteTabView(trip: currentTrip)
                        case .places:
                            PlacesTabView(trip: currentTrip)
                        case .checklist:
                            TripChecklistTabView(trip: currentTrip)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
                .contentMargins(.bottom, AppTheme.Size.tabBarHeight, for: .scrollContent)
                .scrollIndicators(.hidden)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showEdit) {
            EditTripView(trip: currentTrip)
        }
    }

    private var navBar: some View {
        HStack(spacing: 12) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .frame(width: AppTheme.Size.touchTargetMin,
                           height: AppTheme.Size.touchTargetMin)
            }
            Text(currentTrip.title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .lineLimit(2)
            Spacer()
            Button { showEdit = true } label: {
                Image(systemName: "pencil")
                    .font(.system(size: AppTheme.Size.iconSmall))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .frame(width: AppTheme.Size.touchTargetMin,
                           height: AppTheme.Size.touchTargetMin)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
        .frame(height: AppTheme.Size.topBarHeight)
    }

    private var dualMetricCard: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Distance")
                    .font(.system(size: 13))
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                Text("\(currentTrip.distanceKm) km")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppTheme.Colors.accentSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Rectangle()
                .fill(AppTheme.Colors.progressTrack)
                .frame(width: 1, height: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text("Travel Time")
                    .font(.system(size: 13))
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                Text(currentTrip.travelTime.isEmpty ? "—" : currentTrip.travelTime)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
        }
        .padding(16)
        .background(AppTheme.Colors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
    }

    private var segmentedTabs: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach([TripTab.route, .places, .checklist], id: \.self) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tab }
                    } label: {
                        VStack(spacing: 6) {
                            Text(tabLabel(tab))
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(selectedTab == tab
                                    ? AppTheme.Colors.textPrimary
                                    : AppTheme.Colors.textSecondary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 30)

                            if selectedTab == tab {
                                Rectangle()
                                    .fill(AppTheme.Colors.delete)
                                    .frame(height: 2)
                                    .matchedGeometryEffect(id: "tabIndicator", in: tabNamespace)
                            } else {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: 2)
                            }
                        }
                    }
                }
            }
            Rectangle()
                .fill(AppTheme.Colors.accentPrimary.opacity(0.45))
                .frame(height: 1)
        }
    }

    private func tabLabel(_ tab: TripTab) -> String {
        switch tab {
        case .route: return "Route"
        case .places: return "Places"
        case .checklist: return "Checklist"
        }
    }
}
