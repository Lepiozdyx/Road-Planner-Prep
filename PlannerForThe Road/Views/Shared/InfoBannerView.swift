import SwiftUI

struct InfoBannerView: View {
    let icon: String
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: AppTheme.Size.iconSmall))
                .foregroundStyle(AppTheme.Colors.textSecondary)

            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.Colors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
    }
}

#Preview {
    AppShell {
        VStack(spacing: 12) {
            InfoBannerView(icon: "info.circle", message: "💡 You can add stops and places after creating the trip")
            InfoBannerView(icon: "hand.point.left", message: "Swipe left to delete an item")
        }
        .padding()
    }
}
