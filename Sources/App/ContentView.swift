import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if appState.isOnboardingComplete {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .preferredColorScheme(.light)
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            ItemsView()
                .tabItem {
                    Label("Items", systemImage: "archivebox.fill")
                }
                .tag(1)

            SearchView()
                .tabItem {
                    Label("Find", systemImage: "magnifyingglass")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Label("Set", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .tint(Theme.Colors.primary)
    }
}
