import SwiftUI

struct ItemsView: View {
    @StateObject private var viewModel = ItemsViewModel()
    @State private var searchText = ""
    @State private var selectedCategory: ItemCategory?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category filter
                CategoryFilterView(selectedCategory: $selectedCategory)

                // Items list
                if filteredItems.isEmpty {
                    EmptyItemsView()
                } else {
                    List {
                        ForEach(groupedItems.keys.sorted(by: >), id: \.self) { category in
                            Section {
                                ForEach(groupedItems[category] ?? []) { item in
                                    ItemRow(item: item)
                                }
                            } header: {
                                HStack {
                                    Image(systemName: category.icon)
                                    Text(category.rawValue)
                                }
                                .font(.subheadline)
                                .foregroundColor(Theme.Colors.textSecondary)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .background(Theme.Colors.background)
            .navigationTitle("Items")
            .searchable(text: $searchText, prompt: "搜索物品")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showAddItem = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Theme.Colors.primary)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddItem) {
                AddItemView()
            }
        }
    }

    private var filteredItems: [Item] {
        var items = viewModel.items
        if let category = selectedCategory {
            items = items.filter { $0.category == category }
        }
        if !searchText.isEmpty {
            items = items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        return items
    }

    private var groupedItems: [ItemCategory: [Item]] {
        Dictionary(grouping: filteredItems, by: { $0.category })
    }
}

// MARK: - Category Filter

struct CategoryFilterView: View {
    @Binding var selectedCategory: ItemCategory?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.sm) {
                FilterChip(title: "全部", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }

                ForEach(ItemCategory.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.rawValue,
                        icon: category.icon,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm)
        }
        .background(Theme.Colors.cardBackground)
    }
}

struct FilterChip: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(title)
                    .font(.subheadline)
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm)
            .background(isSelected ? Theme.Colors.primary : Theme.Colors.background)
            .foregroundColor(isSelected ? .white : Theme.Colors.textPrimary)
            .cornerRadius(Theme.CornerRadius.large)
        }
    }
}

// MARK: - Item Row

struct ItemRow: View {
    let item: Item

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            // Item icon/image placeholder
            ZStack {
                RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                    .fill(Theme.Colors.primary.opacity(0.1))
                    .frame(width: 50, height: 50)

                if let firstImage = item.images.first,
                   let uiImage = UIImage(data: firstImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.small))
                } else {
                    Image(systemName: item.category.icon)
                        .font(.title3)
                        .foregroundColor(Theme.Colors.primary)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(item.currentLocation?.description ?? "未设置位置")
                    .font(.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(item.usageFrequency)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.Colors.textPrimary)
                Text("使用")
                    .font(.caption2)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
        .padding(.vertical, Theme.Spacing.xs)
    }
}

// MARK: - Empty State

struct EmptyItemsView: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            Spacer()
            Image(systemName: "archivebox")
                .font(.system(size: 60))
                .foregroundColor(Theme.Colors.textSecondary)

            Text("还没有物品")
                .font(.title3)
                .fontWeight(.medium)

            Text("点击右上角 + 添加你的第一个物品")
                .font(.subheadline)
                .foregroundColor(Theme.Colors.textSecondary)

            Spacer()
        }
    }
}

// MARK: - Add Item View

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var selectedCategory: ItemCategory = .other

    var body: some View {
        NavigationStack {
            Form {
                Section("物品信息") {
                    TextField("物品名称", text: $name)

                    Picker("类别", selection: $selectedCategory) {
                        ForEach(ItemCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                }

                Section("添加方式") {
                    Button(action: {}) {
                        Label("拍照添加", systemImage: "camera.fill")
                    }
                    Button(action: {}) {
                        Label("语音添加", systemImage: "mic.fill")
                    }
                }
            }
            .navigationTitle("添加物品")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

// MARK: - ViewModel

@MainActor
class ItemsViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var showAddItem = false
}

#Preview {
    ItemsView()
}
