import Foundation

// MARK: - Space Models

struct Room: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var icon: String
    var containers: [Container]
    var createdAt: Date

    init(id: UUID = UUID(), name: String, icon: String = "house.fill") {
        self.id = id
        self.name = name
        self.icon = icon
        self.containers = []
        self.createdAt = Date()
    }
}

struct Container: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var type: ContainerType
    var parentRoomId: UUID
    var subSpaces: [SubSpace]
    var capacity: Int?
    var createdAt: Date

    init(id: UUID = UUID(), name: String, type: ContainerType, parentRoomId: UUID, capacity: Int? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.parentRoomId = parentRoomId
        self.subSpaces = []
        self.capacity = capacity
        self.createdAt = Date()
    }
}

enum ContainerType: String, Codable, CaseIterable {
    case cabinet = "柜子"
    case drawer = "抽屉"
    case box = "盒子"
    case shelf = "架子"
    case closet = "衣柜"
    case other = "其他"

    var icon: String {
        switch self {
        case .cabinet: return "cabinet.fill"
        case .drawer: return "drawer.fill"
        case .box: return "shippingbox.fill"
        case .shelf: return "books.vertical.fill"
        case .closet: return "tshirt.fill"
        case .other: return "archivebox.fill"
        }
    }
}

struct SubSpace: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var position: String
    var parentContainerId: UUID
    var createdAt: Date

    init(id: UUID = UUID(), name: String, position: String, parentContainerId: UUID) {
        self.id = id
        self.name = name
        self.position = position
        self.parentContainerId = parentContainerId
        self.createdAt = Date()
    }
}

// MARK: - Item Models

struct Item: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var category: ItemCategory
    var attributes: [String: String]
    var images: [Data]
    var currentLocation: LocationRef?
    var historyLocations: [LocationRecord]
    var usageFrequency: Int
    var createdAt: Date
    var updatedAt: Date

    init(id: UUID = UUID(), name: String, category: ItemCategory = .other, attributes: [String: String] = [:]) {
        self.id = id
        self.name = name
        self.category = category
        self.attributes = attributes
        self.images = []
        self.currentLocation = nil
        self.historyLocations = []
        self.usageFrequency = 0
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

enum ItemCategory: String, Codable, CaseIterable {
    case electronics = "电子产品"
    case clothing = "衣物"
    case food = "食品"
    case medicine = "药品"
    case documents = "证件"
    case tools = "工具"
    case daily = "日用品"
    case other = "其他"

    var icon: String {
        switch self {
        case .electronics: return "laptopcomputer"
        case .clothing: return "tshirt.fill"
        case .food: return "fork.knife"
        case .medicine: return "pills.fill"
        case .documents: return "doc.fill"
        case .tools: return "wrench.fill"
        case .daily: return "household.fill"
        case .other: return "archivebox.fill"
        }
    }
}

struct LocationRef: Codable, Equatable {
    var roomId: UUID?
    var containerId: UUID?
    var subSpaceId: UUID?

    var description: String {
        // 会在 ViewModel 中拼接完整路径
        ""
    }
}

struct LocationRecord: Codable, Equatable {
    let location: LocationRef
    let timestamp: Date
    let reason: String?
}

// MARK: - Behavior Log

struct BehaviorLog: Identifiable, Codable {
    let id: UUID
    var type: EventType
    var itemId: UUID?
    var fromLocation: LocationRef?
    var toLocation: LocationRef?
    var timestamp: Date
    var aiProcessed: Bool

    init(id: UUID = UUID(), type: EventType, itemId: UUID? = nil, fromLocation: LocationRef? = nil, toLocation: LocationRef? = nil) {
        self.id = id
        self.type = type
        self.itemId = itemId
        self.fromLocation = fromLocation
        self.toLocation = toLocation
        self.timestamp = Date()
        self.aiProcessed = false
    }
}

enum EventType: String, Codable {
    case search
    case move
    case use
    case discard
}
