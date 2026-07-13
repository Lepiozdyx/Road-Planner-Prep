import SwiftUI

struct ChipView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(isSelected ? AppTheme.Colors.textPrimary : AppTheme.Colors.textSecondary)
                .padding(.horizontal, 16)
                .frame(height: AppTheme.Size.chipHeight)
                .background(isSelected ? AppTheme.Colors.accentPrimary : AppTheme.Colors.chipUnselectedBg)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    AppShell {
        HStack(spacing: 8) {
            ChipView(title: "🏖️ Sea Trip", isSelected: true) {}
            ChipView(title: "🏕️ Mountain", isSelected: false) {}
            ChipView(title: "❄️ Winter", isSelected: false) {}
        }
        .padding()
    }
}
