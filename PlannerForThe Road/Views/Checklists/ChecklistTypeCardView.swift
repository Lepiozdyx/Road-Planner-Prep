import SwiftUI

struct ChecklistTypeCardView: View {
    let type: ChecklistType

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(type.emoji) \(type.name)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(AppTheme.Colors.textTertiary)
            }

            Text("\(type.packedCount) of \(type.totalCount) items packed")
                .font(.system(size: 14))
                .foregroundStyle(AppTheme.Colors.textSecondary)

            ProgressBarView(progress: type.progress)
        }
        .padding(16)
        .background(AppTheme.Colors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
        .shadow(color: Color.black.opacity(0.35), radius: 6, y: 2)
    }
}

#Preview {
    let type = ChecklistType(
        name: "Sea Trip",
        emoji: "🏖️",
        items: [
            ChecklistItem(name: "Sunscreen", quantity: 2, isPacked: true),
            ChecklistItem(name: "Towel", quantity: 2, isPacked: true),
            ChecklistItem(name: "Sunglasses", quantity: 1)
        ]
    )
    AppShell {
        ChecklistTypeCardView(type: type)
            .padding()
    }
}
