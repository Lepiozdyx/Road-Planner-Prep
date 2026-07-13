import SwiftUI

struct TripChecklistTabView: View {
    let trip: Trip
    @Environment(AppDetails.self) private var store

    private var linkedTypes: [ChecklistType] {
        store.checklistTypes.filter { trip.checklistTypeIds.contains($0.id) }
    }

    var body: some View {
        VStack(spacing: 12) {
            if linkedTypes.isEmpty {
                emptyState
            } else {
                ForEach(linkedTypes) { type in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(type.emoji) \(type.name)")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(AppTheme.Colors.textPrimary)
                            Spacer()
                            Text("\(type.packedCount)/\(type.totalCount)")
                                .font(.system(size: 13))
                                .foregroundStyle(AppTheme.Colors.textTertiary)
                        }

                        ProgressBarView(progress: type.progress)

                        ForEach(type.items) { item in
                            HStack(spacing: 12) {
                                Button {
                                    store.toggleItem(id: item.id, inTypeId: type.id)
                                } label: {
                                    Image(systemName: item.isPacked ? "checkmark.square.fill" : "square")
                                        .font(.system(size: 20))
                                        .foregroundStyle(item.isPacked
                                            ? AppTheme.Colors.accentSecondary
                                            : AppTheme.Colors.progressTrack)
                                }
                                .frame(width: AppTheme.Size.touchTargetMin,
                                       height: AppTheme.Size.touchTargetMin)

                                Text(item.name)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(item.isPacked
                                        ? AppTheme.Colors.textTertiary
                                        : AppTheme.Colors.textPrimary)
                                    .strikethrough(item.isPacked, color: AppTheme.Colors.textTertiary)

                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .frame(height: AppTheme.Size.checklistRowHeight)
                            .background(AppTheme.Colors.surfaceElevated)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.input))
                        }
                    }
                    .padding(14)
                    .background(AppTheme.Colors.surfaceElevated.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
                }
            }
        }
        .padding(.top, 12)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "checklist")
                .font(.system(size: 36))
                .foregroundStyle(AppTheme.Colors.textTertiary)
            Text("No checklist linked")
                .font(.system(size: 15))
                .foregroundStyle(AppTheme.Colors.textTertiary)
            Text("Edit the trip to select a checklist type.")
                .font(.system(size: 13))
                .foregroundStyle(AppTheme.Colors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 32)
    }
}

