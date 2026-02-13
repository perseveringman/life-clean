import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.lg) {
                    // Welcome header
                    WelcomeHeader()

                    // Quick stats
                    StatsRow(stats: viewModel.stats)

                    // Recent items
                    RecentItemsSection(items: viewModel.recentItems)

                    // Quick actions
                    QuickActionsSection()
                }
                .padding(Theme.Spacing.md)
            }
            .background(Theme.Colors.background)
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Theme.Colors.primary)
                    }
                }
            }
        }
    }
}

// MARK: - Welcome Header

struct WelcomeHeader: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("你好!")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("今天找东西顺利吗?")
                    .font(.subheadline)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            Spacer()
            Image(systemName: "house.fill")
                .font(.system(size: 40))
                .foregroundColor(Theme.Colors.primary.opacity(0.3))
        }
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.cardBackground)
        .cornerRadius(Theme.CornerRadius.medium)
    }
}

// MARK: - Stats Row

struct StatsRow: View {
    let stats: HomeViewModel.HomeStats

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            StatCard(title: "物品总数", value: "\(stats.totalItems)", icon: "archivebox.fill", color: Theme.Colors.primary)
            StatCard(title: "房间", value: "\(stats.roomCount)", icon: "door.left.hand.open", color: Theme.Colors.secondary)
            StatCard(title: "本月查找", value: "\(stats.searchCount)", icon: "magnifyingglass", color: Theme.Colors.accent)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.cardBackground)
        .cornerRadius(Theme.CornerRadius.medium)
    }
}

// MARK: - Recent Items

struct RecentItemsSection: View {
    let items: [Item]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("最近物品")
                .font(.headline)
                .foregroundColor(Theme.Colors.textPrimary)

            if items.isEmpty {
                EmptyRecentView()
            } else {
                LazyVStack(spacing: Theme.Spacing.sm) {
                    ForEach(items) { item in
                        RecentItemRow(item: item)
                    }
                }
            }
        }
    }
}

struct RecentItemRow: View {
    let item: Item

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: item.category.icon)
                .font(.title3)
                .foregroundColor(Theme.Colors.primary)
                .frame(width: 40, height: 40)
                .background(Theme.Colors.primary.opacity(0.1))
                .cornerRadius(Theme.CornerRadius.small)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.body)
                    .foregroundColor(Theme.Colors.textPrimary)
                Text(item.currentLocation?.description ?? "未设置位置")
                    .font(.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.cardBackground)
        .cornerRadius(Theme.CornerRadius.medium)
    }
}

struct EmptyRecentView: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "archivebox")
                .font(.largeTitle)
                .foregroundColor(Theme.Colors.textSecondary)
            Text("还没有物品")
                .font(.subheadline)
                .foregroundColor(Theme.Colors.textSecondary)
            Text("点击 + 添加你的第一个物品")
                .font(.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.Spacing.xl)
        .background(Theme.Colors.cardBackground)
        .cornerRadius(Theme.CornerRadius.medium)
    }
}

// MARK: - Quick Actions

struct QuickActionsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("快捷操作")
                .font(.headline)
                .foregroundColor(Theme.Colors.textPrimary)

            HStack(spacing: Theme.Spacing.md) {
                QuickActionButton(icon: "mic.fill", title: "语音添加", color: Theme.Colors.primary) {}
                QuickActionButton(icon: "camera.fill", title: "拍照添加", color: Theme.Colors.secondary) {}
                QuickActionButton(icon: "magnifyingglass", title: "查找物品", color: Theme.Colors.accent) {}
            }
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.Spacing.sm) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(color)
                    .cornerRadius(Theme.CornerRadius.medium)
                Text(title)
                    .font(.caption)
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - ViewModel

@MainActor
class HomeViewModel: ObservableObject {
    @Published var stats: HomeStats = HomeStats(totalItems: 0, roomCount: 0, searchCount: 0)
    @Published var recentItems: [Item] = []

    struct HomeStats {
        var totalItems: Int = 0
        var roomCount: Int = 0
        var searchCount: Int = 0
    }
}

#Preview {
    HomeView()
}
