import SwiftUI

@main
struct WaterTrackerApp: App {
    @StateObject private var store = DrinkStore()
    @Environment(\.scenePhase) private var phase

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(store)
        }
        .onChange(of: phase) { _, newPhase in
            if newPhase == .active {
                store.handleDayBoundary()
            }
        }
    }
}
