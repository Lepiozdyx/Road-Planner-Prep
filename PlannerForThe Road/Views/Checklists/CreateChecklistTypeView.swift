import SwiftUI

struct CreateChecklistTypeView: View {
    @Environment(AppDetails.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var emoji = ""

    var body: some View {
        AppShell {
            VStack(spacing: 0) {
                navBar

                ScrollView {
                    VStack(spacing: AppTheme.Spacing.fieldGap) {
                        AppTextField(label: "Type Name",
                                     placeholder: "e.g., Beach Getaway",
                                     text: $name)

                        AppTextField(label: "Emoji",
                                     placeholder: "e.g., 🌴",
                                     text: $emoji)
                        
                        PrimaryButton(title: "Create Type", action: save, isDisabled: name.isEmpty)
                            .padding(.top, AppTheme.Spacing.screenHorizontal)
                    }
                    .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                    .padding(.top, 20)
                }
                .scrollIndicators(.hidden)
            }
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
            Text("Create Custom Type")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
        .frame(height: AppTheme.Size.topBarHeight)
    }

    private func save() {
        let type = ChecklistType(
            name: name,
            emoji: emoji.isEmpty ? "📋" : String(emoji.prefix(2))
        )
        store.addChecklistType(type)
        dismiss()
    }
}
