import SwiftUI

struct EditTripView: View {
    let trip: Trip
    @Environment(AppDetails.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var distanceText: String
    @State private var travelTime: String
    @State private var description: String
    @State private var selectedTypeIds: Set<UUID>
    @FocusState private var isFocused: Bool

    init(trip: Trip) {
        self.trip = trip
        _title = State(initialValue: trip.title)
        _distanceText = State(initialValue: "\(trip.distanceKm)")
        _travelTime = State(initialValue: trip.travelTime)
        _description = State(initialValue: trip.description)
        _selectedTypeIds = State(initialValue: Set(trip.checklistTypeIds))
    }

    var body: some View {
        AppShell {
            VStack(spacing: 0) {
                navBar

                ScrollView {
                    VStack(spacing: AppTheme.Spacing.fieldGap) {
                        AppTextField(label: "Trip Title",
                                     placeholder: "e.g., Paris → Berlin",
                                     text: $title,
                                     focus: $isFocused)

                        AppTextField(label: "Distance (km)",
                                     placeholder: "0",
                                     text: $distanceText,
                                     keyboardType: .numberPad,
                                     focus: $isFocused)

                        AppTextField(label: "Travel Time",
                                     placeholder: "e.g., 20h 30m",
                                     text: $travelTime,
                                     focus: $isFocused)

                        AppTextArea(label: "Description",
                                    placeholder: "12:30 Leave Paris\n15:00 Refueling\n...",
                                    text: $description,
                                    focus: $isFocused)

                        checklistTypeSection

                        Spacer(minLength: 24)
                    }
                    .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                    .padding(.top, 20)
                    .padding(.bottom, AppTheme.Size.primaryButtonHeight + 32)
                }
                .scrollIndicators(.hidden)

                PrimaryButton(title: "Save Changes", action: save)
                    .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                    .padding(.bottom, 24)
            }
            .onTapGesture { isFocused = false }
        }
    }

    private var navBar: some View {
        HStack(spacing: 12) {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .frame(width: AppTheme.Size.touchTargetMin,
                           height: AppTheme.Size.touchTargetMin)
            }
            Text("Edit Trip")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
        .frame(height: AppTheme.Size.topBarHeight)
    }

    private var checklistTypeSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.labelToField) {
            Text("Checklist Type")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(AppTheme.Colors.textSecondary)

            FlowLayout(spacing: 8) {
                ForEach(store.checklistTypes) { type in
                    ChipView(
                        title: "\(type.emoji) \(type.name)",
                        isSelected: selectedTypeIds.contains(type.id)
                    ) {
                        if selectedTypeIds.contains(type.id) {
                            selectedTypeIds.remove(type.id)
                        } else {
                            selectedTypeIds.insert(type.id)
                        }
                    }
                }
            }
        }
    }

    private func save() {
        var updated = trip
        updated.title = title
        updated.distanceKm = Int(distanceText) ?? 0
        updated.travelTime = travelTime
        updated.description = description
        updated.checklistTypeIds = Array(selectedTypeIds)
        store.updateTrip(updated)
        dismiss()
    }
}
