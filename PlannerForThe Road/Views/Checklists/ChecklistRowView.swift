import SwiftUI

struct ChecklistRowView: View {
    let item: ChecklistItem
    let typeId: UUID
    @Environment(AppDetails.self) private var store

    var body: some View {
        HStack(spacing: 0) {
            Button {
                store.toggleItem(id: item.id, inTypeId: typeId)
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: item.isPacked ? "checkmark.square.fill" : "square")
                        .font(.system(size: 20))
                        .foregroundStyle(item.isPacked
                            ? AppTheme.Colors.accentSecondary
                            : AppTheme.Colors.progressTrack)
                        .frame(width: AppTheme.Size.touchTargetMin)

                    Text(item.name)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(item.isPacked
                            ? AppTheme.Colors.textTertiary
                            : AppTheme.Colors.textPrimary)
                        .strikethrough(item.isPacked, color: AppTheme.Colors.textTertiary)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: AppTheme.Size.checklistRowHeight)
                .background(AppTheme.Colors.surfaceElevated)
            }
            .buttonStyle(.plain)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.input))
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                store.deleteItem(id: item.id, fromTypeId: typeId)
            } label: {
                Image(systemName: "trash")
            }
            .tint(AppTheme.Colors.delete)
        }
    }
}

