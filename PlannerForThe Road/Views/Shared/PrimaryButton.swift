import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: AppTheme.Size.primaryButtonHeight)
                .background(AppTheme.Colors.accentPrimary)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.button))
                .shadow(color: Color(red: 1, green: 0.18, blue: 0.18, opacity: 0.15), radius: 10)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
    }
}

#Preview {
    AppShell {
        VStack(spacing: 16) {
            PrimaryButton(title: "Save Trip") {}
            PrimaryButton(title: "Disabled Button", action: {}, isDisabled: true)
        }
        .padding()
    }
}
