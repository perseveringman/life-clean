import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentStep = 0
    @State private var selectedMode: AppState.AppMode = .personal

    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(index <= currentStep ? Theme.Colors.primary : Theme.Colors.divider)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, Theme.Spacing.xl)

            Spacer()

            // Content based on step
            switch currentStep {
            case 0:
                ModeSelectionView(selectedMode: $selectedMode)
            case 1:
                QuickSetupView()
            case 2:
                CompletionView()
            default:
                EmptyView()
            }

            Spacer()

            // Bottom button
            Button(action: nextStep) {
                Text(currentStep == 2 ? "开始使用" : "下一步")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Theme.Spacing.md)
                    .background(Theme.Colors.primary)
                    .cornerRadius(Theme.CornerRadius.medium)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Theme.Colors.background)
    }

    private func nextStep() {
        if currentStep < 2 {
            withAnimation {
                currentStep += 1
            }
        } else {
            appState.currentMode = selectedMode
            appState.isOnboardingComplete = true
        }
    }
}

// MARK: - Mode Selection

struct ModeSelectionView: View {
    @Binding var selectedMode: AppState.AppMode

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Image(systemName: "house.fill")
                .font(.system(size: 80))
                .foregroundColor(Theme.Colors.primary)

            Text("欢迎使用 LifeClean")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("智能物品管理，让找东西变得简单")
                .font(.body)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)

            VStack(spacing: Theme.Spacing.md) {
                ModeCard(
                    icon: "person.fill",
                    title: "个人模式",
                    description: "管理自己的物品",
                    isSelected: selectedMode == .personal
                ) {
                    selectedMode = .personal
                }

                ModeCard(
                    icon: "person.3.fill",
                    title: "家庭模式",
                    description: "与家人共享管理",
                    isSelected: selectedMode == .family
                ) {
                    selectedMode = .family
                }
            }
            .padding(.top, Theme.Spacing.lg)
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }
}

struct ModeCard: View {
    let icon: String
    let title: String
    let description: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.md) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? Theme.Colors.primary : Theme.Colors.textSecondary)
                    .frame(width: 40)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Theme.Colors.primary)
                }
            }
            .padding(Theme.Spacing.md)
            .background(Theme.Colors.cardBackground)
            .cornerRadius(Theme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .stroke(isSelected ? Theme.Colors.primary : Color.clear, lineWidth: 2)
            )
        }
    }
}

// MARK: - Quick Setup

struct QuickSetupView: View {
    @State private var rooms: [String] = ["客厅", "卧室", "厨房"]
    @State private var newRoomName = ""
    @State private var hasCompleted = false

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Image(systemName: "gearshape.2.fill")
                .font(.system(size: 60))
                .foregroundColor(Theme.Colors.secondary)

            Text("快速设置")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("添加你的房间和收纳空间")
                .font(.body)
                .foregroundColor(Theme.Colors.textSecondary)

            // Room list
            VStack(spacing: Theme.Spacing.sm) {
                ForEach(rooms, id: \.self) { room in
                    HStack {
                        Image(systemName: "door.left.hand.open")
                            .foregroundColor(Theme.Colors.textSecondary)
                        Text(room)
                            .foregroundColor(Theme.Colors.textPrimary)
                        Spacer()
                    }
                    .padding(Theme.Spacing.md)
                    .background(Theme.Colors.cardBackground)
                    .cornerRadius(Theme.CornerRadius.small)
                }
            }
            .padding(.top, Theme.Spacing.md)

            // Add room input
            HStack {
                TextField("添加房间", text: $newRoomName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: addRoom) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Theme.Colors.primary)
                        .font(.title2)
                }
                .disabled(newRoomName.isEmpty)
            }
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }

    private func addRoom() {
        guard !newRoomName.isEmpty else { return }
        rooms.append(newRoomName)
        newRoomName = ""
    }
}

// MARK: - Completion

struct CompletionView: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(Theme.Colors.accent)

            Text("设置完成!")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("现在你可以开始\n管理你的物品了")
                .font(.body)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)

            // Demo hint
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                HStack {
                    Image(systemName: "mic.fill")
                    Text("试试对它说:")
                }
                .font(.headline)
                .foregroundColor(Theme.Colors.primary)

                Text("\"我的钥匙放在玄关柜\"")
                    .font(.subheadline)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .padding(.leading, Theme.Spacing.md)
            }
            .padding(Theme.Spacing.md)
            .background(Theme.Colors.primary.opacity(0.1))
            .cornerRadius(Theme.CornerRadius.medium)
            .padding(.top, Theme.Spacing.md)
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
