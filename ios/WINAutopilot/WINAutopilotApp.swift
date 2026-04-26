import SwiftUI

@main
struct WINAutopilotApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ConsumerAppStack()
                .environment(appState)
                .preferredColorScheme(.light)
        }
    }
}
