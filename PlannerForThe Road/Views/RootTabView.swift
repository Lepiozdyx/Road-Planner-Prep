import SwiftUI

enum AppTab {
    case trips, checklists, statistics
}

struct RootTabView: View {
    @State private var selectedTab: AppTab = .trips

    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .trips:
                    TripsView()
                case .checklists:
                    ChecklistsView()
                case .statistics:
                    StatisticsView()
                }
            }
            .safeAreaInset(edge: .bottom) {
                BottomTabBar(selectedTab: $selectedTab)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
            }
        }
    }
}

struct BottomTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 0) {
            tabItem(icon: "map", label: "Trips", tab: .trips)
            tabItem(icon: "checklist", label: "Checklists", tab: .checklists)
            tabItem(icon: "chart.bar", label: "Statistics", tab: .statistics)
        }
        .frame(height: AppTheme.Size.tabBarHeight)
        .background(AppTheme.Colors.tabBarBg)
    }

    @ViewBuilder
    private func tabItem(icon: String, label: String, tab: AppTab) -> some View {
        let isActive = selectedTab == tab
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.system(size: 12, weight: .regular))
            }
            .foregroundStyle(isActive ? AppTheme.Colors.accentPrimary : AppTheme.Colors.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.top, 10)
            .contentShape(Rectangle())
            .animation(.default, value: isActive)
        }
    }
}
