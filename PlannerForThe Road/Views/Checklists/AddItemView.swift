import SwiftUI
import PhotosUI

struct AddItemView: View {
    let typeId: UUID
    @Environment(AppDetails.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var quantityText = "1"
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    @FocusState private var isFocused: Bool

    var body: some View {
        AppShell {
            VStack(spacing: 0) {
                navBar

                ScrollView {
                    VStack(spacing: AppTheme.Spacing.fieldGap) {
                        AppTextField(label: "Item Name",
                                     placeholder: "e.g., Sunscreen",
                                     text: $name,
                                     focus: $isFocused)

                        AppTextField(label: "Quantity",
                                     placeholder: "1",
                                     text: $quantityText,
                                     keyboardType: .numberPad,
                                     focus: $isFocused)

                        photoSection
                    }
                    .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                    .padding(.top, 20)
                    .padding(.bottom, AppTheme.Size.primaryButtonHeight + 32)
                }
                .scrollIndicators(.hidden)

                PrimaryButton(title: "Add Item", action: save, isDisabled: name.isEmpty)
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
            Text("Add Item")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
        .frame(height: AppTheme.Size.topBarHeight)
    }

    private var photoSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.labelToField) {
            Text("Photo (Optional)")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(AppTheme.Colors.textSecondary)

            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.Radius.card)
                        .fill(AppTheme.Colors.surfaceElevated)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.card)
                                .strokeBorder(AppTheme.Colors.accentPrimary.opacity(0.2), lineWidth: 1)
                        )
                        .frame(height: AppTheme.Size.photoDropzoneHeight)

                    if let data = photoData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: AppTheme.Size.photoDropzoneHeight)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
                    } else {
                        Text("Tap to add photo")
                            .font(.system(size: 16))
                            .foregroundStyle(AppTheme.Colors.textTertiary)
                    }
                }
            }
            .onChange(of: selectedPhoto) { _, newItem in
                Task {
                    photoData = try? await newItem?.loadTransferable(type: Data.self)
                }
            }
        }
    }

    private func save() {
        let item = ChecklistItem(
            name: name,
            quantity: Int(quantityText) ?? 1,
            photoData: photoData
        )
        store.addItem(item, toTypeId: typeId)
        dismiss()
    }
}

