import SwiftUI

struct AddStopView: View {
    let tripId: UUID
    @Environment(AppDetails.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var distanceText = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        AppShell {
            VStack(spacing: 0) {
                navBar

                ScrollView {
                    VStack(spacing: AppTheme.Spacing.fieldGap) {
                        AppTextField(label: "City / Stop Name",
                                     placeholder: "e.g., Nizhny Novgorod",
                                     text: $name,
                                     focus: $isFocused)

                        AppTextField(label: "Distance from Start (km)",
                                     placeholder: "e.g., 450",
                                     text: $distanceText,
                                     keyboardType: .numberPad,
                                     focus: $isFocused)
                    }
                    .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                    .padding(.top, 20)
                    .padding(.bottom, AppTheme.Size.primaryButtonHeight + 32)
                }
                .scrollIndicators(.hidden)

                PrimaryButton(title: "Add Stop", action: save, isDisabled: name.isEmpty)
                    .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                    .padding(.bottom, AppTheme.Size.tabBarHeight)
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
            Text("Add Stop")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
        .frame(height: AppTheme.Size.topBarHeight)
    }

    private func save() {
        let stop = Stop(
            name: name,
            distanceFromStart: Int(distanceText) ?? 0
        )
        store.addStop(stop, toTripId: tripId)
        dismiss()
    }
}

struct AddPlaceView: View {
    let stopId: UUID
    let tripId: UUID
    @Environment(AppDetails.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""

    var body: some View {
        AppShell {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                            .frame(width: AppTheme.Size.touchTargetMin,
                                   height: AppTheme.Size.touchTargetMin)
                    }
                    Text("Add Place")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                .frame(height: AppTheme.Size.topBarHeight)

                VStack(spacing: AppTheme.Spacing.fieldGap) {
                    AppTextField(label: "Place Name",
                                 placeholder: "e.g., Nizhny Novgorod Kremlin",
                                 text: $name)
                }
                .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                .padding(.top, 20)

                Spacer()

                PrimaryButton(title: "Add Place", action: save, isDisabled: name.isEmpty)
                    .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                    .padding(.bottom, 24)
            }
        }
    }

    private func save() {
        store.addPlace(Place(name: name), toStopId: stopId, tripId: tripId)
        dismiss()
    }
}
