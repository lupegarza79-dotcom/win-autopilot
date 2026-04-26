import SwiftUI

struct ContentView: View {
    var body: some View {
        AppTabs()
    }
}

#Preview {
    ContentView()
        .environment(AppState())
}
