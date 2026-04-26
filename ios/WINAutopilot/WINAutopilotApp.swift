import SwiftUI

@main
struct WINAutopilotApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            AppTabs()
                .environment(appState)
                .preferredColorScheme(.dark)
        }
    }
}
