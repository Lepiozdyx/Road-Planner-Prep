import SwiftUI

struct ProgressBarView: View {
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 999)
                    .fill(AppTheme.Colors.progressTrack)
                    .frame(height: AppTheme.Size.progressBarHeight)

                RoundedRectangle(cornerRadius: 999)
                    .fill(AppTheme.Colors.accentSecondary)
                    .frame(width: max(0, geo.size.width * CGFloat(progress)),
                           height: AppTheme.Size.progressBarHeight)
            }
        }
        .frame(height: AppTheme.Size.progressBarHeight)
    }
}

#Preview {
    AppShell {
        VStack(spacing: 16) {
            ProgressBarView(progress: 0.0)
            ProgressBarView(progress: 0.35)
            ProgressBarView(progress: 0.75)
            ProgressBarView(progress: 1.0)
        }
        .padding()
    }
}
