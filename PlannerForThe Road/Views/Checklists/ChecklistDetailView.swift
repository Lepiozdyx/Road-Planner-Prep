import SwiftUI

struct ChecklistDetailView: View {
    let typeId: UUID
    @Environment(AppDetails.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var showAddItem = false

    private var checklistType: ChecklistType? {
        store.checklistTypes.first(where: { $0.id == typeId })
    }

    var body: some View {
        AppShell {
            VStack(spacing: 0) {
                navBar

                if let type = checklistType {
                    List {
                        Section {
                            progressCard(type: type)
                                .listRowBackground(Color.clear)
                                .listRowInsets(.init(top: 0, leading: 0, bottom: 12, trailing: 0))
                        }

                        Section {
                            ForEach(type.items) { item in
                                ChecklistRowView(item: item, typeId: typeId)
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                                    .listRowSeparator(.hidden)
                            }
                        }

                        Section {
                            PrimaryButton(title: "+ Add Item") {
                                showAddItem = true
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                            .listRowSeparator(.hidden)

                            InfoBannerView(icon: "hand.point.left", message: "Swipe left to delete an item")
                                .listRowBackground(Color.clear)
                                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddItem) {
            if let type = checklistType {
                AddItemView(typeId: type.id)
            }
        }
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
            if let type = checklistType {
                Text("\(type.emoji) \(type.name)")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
            }
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
        .frame(height: AppTheme.Size.topBarHeight)
    }

    private func progressCard(type: ChecklistType) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Packing Progress")
                    .font(.system(size: 14))
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                Spacer()
                Text("\(Int(type.progress * 100))%")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(AppTheme.Colors.accentSecondary)
            }
            ProgressBarView(progress: type.progress)
            Text("\(type.packedCount) of \(type.totalCount) items packed")
                .font(.system(size: 13))
                .foregroundStyle(AppTheme.Colors.accentSecondary)
        }
        .padding(16)
        .background(AppTheme.Colors.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
    }
}

