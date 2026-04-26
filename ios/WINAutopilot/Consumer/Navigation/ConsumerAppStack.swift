import SwiftUI

struct ConsumerAppStack: View {
    var body: some View {
        NavigationStack {
            MatchScreen()
                .navigationBarHidden(true)
        }
    }
}
