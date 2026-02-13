import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar
                SearchBarView(
                    text: $viewModel.searchText,
                    isRecording: $viewModel.isRecording,
                    isFocused: $isSearchFocused,
                    onSubmit: { viewModel.search() },
                    onMicTap: { viewModel.toggleRecording() }
                )
                .padding(Theme.Spacing.md)

                // Results or suggestions
                if viewModel.searchText.isEmpty {
                    SearchSuggestionsView(suggestions: viewModel.suggestions)
                } else if viewModel.isSearching {
                    LoadingView()
                } else if let result = viewModel.searchResult {
                    SearchResultView(result: result)
                } else {
                    NoResultsView(query: viewModel.searchText)
                }

                Spacer()
            }
            .background(Theme.Colors.background)
            .navigationTitle("查找")
        }
    }
}

// MARK: - Search Bar

struct SearchBarView: View {
    @Binding var text: String
    @Binding var isRecording: Bool
    var isFocused: FocusState<Bool>.Binding
    var onSubmit: () -> Void
    var onMicTap: () -> Void

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Theme.Colors.textSecondary)

                TextField("搜索物品...", text: $text)
                    .focused(isFocused)
                    .submitLabel(.search)
                    .onSubmit(onSubmit)

                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }
            }
            .padding(Theme.Spacing.md)
            .background(Theme.Colors.cardBackground)
            .cornerRadius(Theme.CornerRadius.medium)

            // Mic button
            Button(action: onMicTap) {
                Image(systemName: isRecording ? "mic.fill" : "mic")
                    .font(.title3)
                    .foregroundColor(isRecording ? .white : Theme.Colors.primary)
                    .frame(width: 44, height: 44)
                    .background(isRecording ? Theme.Colors.accent : Theme.Colors.primary.opacity(0.1))
                    .cornerRadius(Theme.CornerRadius.medium)
            }
        }
    }
}

// MARK: - Suggestions

struct SearchSuggestionsView: View {
    let suggestions: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("最近搜索")
                .font(.headline)
                .foregroundColor(Theme.Colors.textPrimary)
                .padding(.horizontal, Theme.Spacing.md)

            if suggestions.isEmpty {
                VStack(spacing: Theme.Spacing.md) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(Theme.Colors.textSecondary.opacity(0.5))

                    Text("试试说:")
                        .font(.subheadline)
                        .foregroundColor(Theme.Colors.textSecondary)

                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        SuggestionChip(text: "我的钥匙在哪")
                        SuggestionChip(text: "充电器在哪里")
                        SuggestionChip(text: "找找雨伞")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, Theme.Spacing.xl)
            } else {
                LazyVStack(spacing: Theme.Spacing.sm) {
                    ForEach(suggestions, id: \.self) { suggestion in
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(Theme.Colors.textSecondary)
                            Text(suggestion)
                                .foregroundColor(Theme.Colors.textPrimary)
                            Spacer()
                        }
                        .padding(Theme.Spacing.md)
                        .background(Theme.Colors.cardBackground)
                        .cornerRadius(Theme.CornerRadius.small)
                    }
                }
                .padding(.horizontal, Theme.Spacing.md)
            }
        }
    }
}

struct SuggestionChip: View {
    let text: String

    var body: some View {
        HStack {
            Image(systemName: "waveform")
                .font(.caption)
                .foregroundColor(Theme.Colors.primary)
            Text(text)
                .font(.subheadline)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.vertical, Theme.Spacing.sm)
        .background(Theme.Colors.cardBackground)
        .cornerRadius(Theme.CornerRadius.large)
    }
}

// MARK: - Search Result

struct SearchResultView: View {
    let result: SearchResult

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Found indicator
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("找到了!")
                    .font(.headline)
            }

            // Item info
            VStack(spacing: Theme.Spacing.sm) {
                Image(systemName: result.item.category.icon)
                    .font(.system(size: 50))
                    .foregroundColor(Theme.Colors.primary)

                Text(result.item.name)
                    .font(.title2)
                    .fontWeight(.bold)
            }

            // Location path
            VStack(spacing: Theme.Spacing.sm) {
                Text("物品位置")
                    .font(.subheadline)
                    .foregroundColor(Theme.Colors.textSecondary)

                HStack(spacing: Theme.Spacing.sm) {
                    ForEach(Array(result.locationPath.enumerated()), id: \.offset) { index, location in
                        if index > 0 {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }

                        VStack(spacing: 4) {
                            Image(systemName: location.icon)
                                .font(.title3)
                            Text(location.name)
                                .font(.caption)
                        }
                        .padding(Theme.Spacing.md)
                        .background(Theme.Colors.primary.opacity(0.1))
                        .cornerRadius(Theme.CornerRadius.medium)
                    }
                }
            }

            // Action buttons
            HStack(spacing: Theme.Spacing.md) {
                Button(action: {}) {
                    Label("已找到", systemImage: "checkmark")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(Theme.Spacing.md)
                        .background(Theme.Colors.primary)
                        .cornerRadius(Theme.CornerRadius.medium)
                }

                Button(action: {}) {
                    Label("移动物品", systemImage: "arrow.right.arrow.left")
                        .font(.subheadline)
                        .foregroundColor(Theme.Colors.primary)
                        .padding(Theme.Spacing.md)
                        .background(Theme.Colors.primary.opacity(0.1))
                        .cornerRadius(Theme.CornerRadius.medium)
                }
            }
        }
        .padding(Theme.Spacing.lg)
    }
}

// MARK: - Loading & Empty

struct LoadingView: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            ProgressView()
                .scaleEffect(1.5)
            Text("正在查找...")
                .font(.subheadline)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct NoResultsView: View {
    let query: String

    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 50))
                .foregroundColor(Theme.Colors.textSecondary)

            Text("未找到 \"\(query)\"")
                .font(.headline)

            Text("试试添加这个物品")
                .font(.subheadline)
                .foregroundColor(Theme.Colors.textSecondary)

            Button(action: {}) {
                Text("添加物品")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(Theme.Spacing.md)
                    .background(Theme.Colors.primary)
                    .cornerRadius(Theme.CornerRadius.medium)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Models

struct SearchResult {
    let item: Item
    let locationPath: [LocationNode]
}

struct LocationNode {
    let name: String
    let icon: String
}

// MARK: - ViewModel

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var isRecording = false
    @Published var isSearching = false
    @Published var searchResult: SearchResult?
    @Published var suggestions: [String] = ["钥匙", "充电器", "雨伞"]

    func search() {
        guard !searchText.isEmpty else { return }

        isSearching = true
        searchResult = nil

        // Simulate search
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            // Mock result
            let mockItem = Item(name: self?.searchText ?? "物品", category: .daily)
            let mockResult = SearchResult(
                item: mockItem,
                locationPath: [
                    LocationNode(name: "客厅", icon: "sofa.fill"),
                    LocationNode(name: "电视柜", icon: "tv.fill"),
                    LocationNode(name: "抽屉", icon: "drawer.fill")
                ]
            )
            self?.searchResult = mockResult
            self?.isSearching = false
        }
    }

    func toggleRecording() {
        isRecording.toggle()
        if isRecording {
            // Start recording
        } else {
            // Stop recording and search
            search()
        }
    }
}

#Preview {
    SearchView()
}
