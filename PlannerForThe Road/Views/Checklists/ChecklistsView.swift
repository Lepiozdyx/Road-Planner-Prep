import SwiftUI

struct ChecklistsView: View {
    @Environment(AppDetails.self) private var store
    @State private var showCreate = false
    @State private var checklistTypeToDelete: ChecklistType?

    var body: some View {
        NavigationStack {
            AppShell {
                VStack(spacing: 0) {
                    titleBar

                    List {
                        ForEach(store.checklistTypes) { type in
                            ZStack {
                                NavigationLink(value: type.id) { EmptyView() }
                                    .opacity(0)
                                ChecklistTypeCardView(type: type)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: AppTheme.Spacing.listItemGap, trailing: 0))
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    checklistTypeToDelete = type
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                    .padding(.top, 16)
                    .scrollIndicators(.hidden)
                    .contentMargins(
                        .bottom,
                        AppTheme.Size.primaryButtonHeight + AppTheme.Size.tabBarHeight + 40,
                        for: .scrollContent
                    )

                    PrimaryButton(title: "+ Create Custom Type") {
                        showCreate = true
                    }
                    .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
                    .padding(.bottom, 16)
                    .navigationDestination(isPresented: $showCreate) {
                        CreateChecklistTypeView()
                    }
                }
                .padding(.bottom, AppTheme.Size.tabBarHeight)
            }
            .navigationDestination(for: UUID.self) { typeId in
                ChecklistDetailView(typeId: typeId)
            }
            .navigationBarHidden(true)
            .alert("Delete Checklist?", isPresented: Binding(
                get: { checklistTypeToDelete != nil },
                set: { if !$0 { checklistTypeToDelete = nil } }
            )) {
                Button("Delete", role: .destructive) {
                    if let type = checklistTypeToDelete { store.deleteChecklistType(id: type.id) }
                    checklistTypeToDelete = nil
                }
                Button("Cancel", role: .cancel) { checklistTypeToDelete = nil }
            } message: {
                Text("\(checklistTypeToDelete.map { "\($0.emoji) \($0.name)" } ?? "") will be permanently deleted.")
            }
        }
    }

    private var titleBar: some View {
        HStack {
            Text("Checklists")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.screenHorizontal)
        .frame(height: AppTheme.Size.topBarHeight)
    }
}

