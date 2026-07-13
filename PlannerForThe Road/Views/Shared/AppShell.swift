import SwiftUI

struct AppShell<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            AppTheme.Colors.backgroundGradient
                .ignoresSafeArea()
            content
        }
        .tint(AppTheme.Colors.accentPrimary)
    }
}

#Preview {
    AppShell {
        VStack(spacing: 16) {
            Text("AppShell Preview")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Text("Background gradient fills the screen")
                .font(.system(size: 15))
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
        .padding()
    }
}
