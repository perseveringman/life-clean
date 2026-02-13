import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var isSyncEnabled = true
    @State private var isDarkMode = false

    var body: some View {
        NavigationStack {
            List {
                // Account section
                Section("账户") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(Theme.Colors.primary)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("个人账户")
                                .font(.body)
                            Text("管理你的物品数据")
                                .font(.caption)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }

                // Sync section
                Section("数据同步") {
                    Toggle(isOn: $isSyncEnabled) {
                        Label("iCloud 同步", systemImage: "icloud.fill")
                    }

                    if appState.currentMode == .family {
                        Button(action: {}) {
                            Label("家庭共享设置", systemImage: "person.3.fill")
                        }
                    }
                }

                // Preferences section
                Section("偏好设置") {
                    Toggle(isOn: $isDarkMode) {
                        Label("深色模式", systemImage: "moon.fill")
                    }

                    NavigationLink(destination: Text("通知设置")) {
                        Label("通知设置", systemImage: "bell.fill")
                    }

                    NavigationLink(destination: Text("语音设置")) {
                        Label("语音识别", systemImage: "mic.fill")
                    }
                }

                // Space management
                Section("空间管理") {
                    NavigationLink(destination: Text("房间管理")) {
                        Label("房间", systemImage: "door.left.hand.open")
                    }

                    NavigationLink(destination: Text("容器管理")) {
                        Label("容器", systemImage: "cabinet.fill")
                    }
                }

                // AI & Stats
                Section("AI 与统计") {
                    NavigationLink(destination: Text("AI 推荐历史")) {
                        Label("AI 推荐记录", systemImage: "sparkles")
                    }

                    NavigationLink(destination: Text("使用统计")) {
                        Label("使用统计", systemImage: "chart.bar.fill")
                    }
                }

                // About section
                Section("关于") {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(Theme.Colors.textSecondary)
                    }

                    Link(destination: URL(string: "https://example.com/privacy")!) {
                        Label("隐私政策", systemImage: "hand.raised.fill")
                    }

                    Link(destination: URL(string: "https://example.com/terms")!) {
                        Label("服务条款", systemImage: "doc.text.fill")
                    }
                }

                // Danger zone
                Section {
                    Button(role: .destructive, action: {}) {
                        Label("导出所有数据", systemImage: "square.and.arrow.up")
                    }

                    Button(role: .destructive, action: {}) {
                        Label("删除所有数据", systemImage: "trash.fill")
                    }
                } footer: {
                    Text("删除数据后无法恢复，请谨慎操作")
                }
            }
            .navigationTitle("设置")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
