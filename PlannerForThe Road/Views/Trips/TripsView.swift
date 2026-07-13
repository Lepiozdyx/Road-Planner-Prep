import SwiftUI

struct TripsView: View {
    @Environment(AppDetails.self) private var store
    @State private var showCreate = false
    @State private var tripToDelete: Trip?

    var body: some View {
        NavigationStack {
            AppShell {
                VStack(spacing: 0) {
                    titleBar

                    if store.trips.isEmpty {
                        emptyState
                    } else {
                        List {
                            ForEach(store.trips) { trip in
                                ZStack {
                                    NavigationLink(value: trip) { EmptyView() }
                                        .opacity(0)
                                    TripCardView(trip: trip)
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 0, leading: 0, bottom: AppTheme.Spacing.cardGap, trailing: 0))
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        tripToDelete = trip
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                        .padding(.top, 16)
                        .scrollIndicators(.hidden)
                        .contentMargins(
                            .bottom,
                            AppTheme.Size.primaryButtonHeight + AppTheme.Size.tabBarHeight + 40,
                            for: .scrollContent
                        )
                    }

                    newTripButton
                        .padding(.bottom, AppTheme.Size.tabBarHeight)
                }
            }
            .navigationDestination(for: Trip.self) { trip in
                TripDetailView(trip: trip)
            }
            .navigationBarHidden(true)
            .alert("Delete Trip?", isPresented: Binding(
                get: { tripToDelete != nil },
                set: { if !$0 { tripToDelete = nil } }
            )) {
                Button("Delete", role: .destructive) {
                    if let trip = tripToDelete { store.deleteTrip(id: trip.id) }
                    tripToDelete = nil
                }
                Button("Cancel", role: .cancel) { tripToDelete = nil }
            } message: {
                Text("\(tripToDelete?.title ?? "") will be permanently deleted.")
            }
        }
    }

    private var titleBar: some View {
        HStack {
            Text("Trips")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
        .frame(height: AppTheme.Size.topBarHeight)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "map")
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.Colors.textTertiary)
            Text("No trips yet")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Text("Tap + New Trip to plan your first road trip")
                .font(.system(size: 15))
                .foregroundStyle(AppTheme.Colors.textTertiary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
    }

    private var newTripButton: some View {
        PrimaryButton(title: "+ New Trip") {
            showCreate = true
        }
        .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
        .padding(.bottom, 16)
        .navigationDestination(isPresented: $showCreate) {
            CreateTripView()
        }
    }
}
