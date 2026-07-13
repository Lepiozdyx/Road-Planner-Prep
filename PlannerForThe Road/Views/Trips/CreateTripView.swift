import SwiftUI

struct CreateTripView: View {
    @Environment(AppDetails.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var distanceText = "0"
    @State private var travelTime = ""
    @State private var description = ""
    @State private var selectedTypeIds: Set<UUID> = []
    @FocusState private var isFocused: Bool

    private var isValid: Bool { !title.trimmingCharacters(in: .whitespaces).isEmpty }

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

                        InfoBannerView(
                            icon: "info.circle",
                            message: "💡 You can add stops and places after creating the trip"
                        )

                        Spacer(minLength: 24)
                    }
                    .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                    .padding(.top, 20)
                    .padding(.bottom, AppTheme.Size.primaryButtonHeight + 32)
                }
                .scrollIndicators(.hidden)
                
                bottomButton
                    .padding(.bottom, AppTheme.Size.tabBarHeight)
            }
            .onTapGesture { isFocused = false }
        }
        .navigationBarHidden(true)
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
            Text("Create Trip")
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

            if store.checklistTypes.isEmpty {
                Text("No checklist types yet. Create one in the Checklists tab.")
                    .font(.system(size: 13))
                    .foregroundStyle(AppTheme.Colors.textTertiary)
            } else {
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
    }

    private var bottomButton: some View {
        PrimaryButton(title: "Save Trip", action: saveTrip, isDisabled: !isValid)
            .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
            .padding(.bottom, 24)
            .background(Color.clear)
    }

    private func saveTrip() {
        let distance = Int(distanceText) ?? 0
        let trip = Trip(
            title: title,
            distanceKm: distance,
            travelTime: travelTime,
            description: description,
            checklistTypeIds: Array(selectedTypeIds)
        )
        store.addTrip(trip)
        dismiss()
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var height: CGFloat = 0
        var x: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                height += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }
        height += rowHeight
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }
    }
}
