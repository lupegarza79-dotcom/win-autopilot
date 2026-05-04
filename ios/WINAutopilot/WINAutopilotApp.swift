import SwiftUI

@main
struct WINAutopilotApp: App {
    @State private var appState = AppState()
    @State private var showGhost: Bool = false
    @State private var showSource: Bool = false

    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .topTrailing) {
                ConsumerAppStack()
                    .environment(appState)
                    .preferredColorScheme(.light)

                HStack(spacing: 8) {
                    Button {
                        showSource = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "bolt.fill")
                            Text("SOURCE")
                        }
                        .font(.system(size: 11, weight: .heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.20, green: 0.55, blue: 1.0), Color(red: 0.10, green: 0.35, blue: 0.85)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Capsule())
                    }

                    Button {
                        showGhost = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "storefront.fill")
                            Text("Merchant")
                        }
                        .font(.system(size: 11, weight: .heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.55))
                        .clipShape(Capsule())
                    }
                }
                .padding(.top, 8)
                .padding(.trailing, 12)
            }
            .fullScreenCover(isPresented: $showSource) {
                SourceMatchFlow(onClose: { showSource = false })
            }
            .fullScreenCover(isPresented: $showGhost) {
                GhostSetupFlow()
                    .overlay(alignment: .topLeading) {
                        Button {
                            showGhost = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .heavy))
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.55))
                                .clipShape(Circle())
                        }
                        .padding(.top, 8)
                        .padding(.leading, 12)
                    }
            }
        }
    }
}
