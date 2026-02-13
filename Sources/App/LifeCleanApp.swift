import SwiftUI

@main
struct LifeCleanApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

// MARK: - App State
@MainActor
class AppState: ObservableObject {
    @Published var isOnboardingComplete: Bool = false
    @Published var currentMode: AppMode = .personal

    enum AppMode {
        case personal
        case family
    }
}
