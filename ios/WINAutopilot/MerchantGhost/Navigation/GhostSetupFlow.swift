import SwiftUI

enum GhostStep: Hashable {
    case inventory, slowHours, marginGuard, preview
}

struct GhostSetupFlow: View {
    @State private var store = GhostStore()
    @State private var path: [GhostStep] = []
    @State private var toast: String?

    var body: some View {
        NavigationStack(path: $path) {
            BusinessSnapshotScreen(store: store) {
                path.append(.inventory)
            }
            .navigationDestination(for: GhostStep.self) { step in
                switch step {
                case .inventory:
                    InventoryScreen(store: store) { path.append(.slowHours) }
                case .slowHours:
                    SlowHoursScreen(store: store) { path.append(.marginGuard) }
                case .marginGuard:
                    MarginGuardScreen(store: store) {
                        store.generateDrafts()
                        path.append(.preview)
                    }
                case .preview:
                    AIOfferPreviewScreen(store: store) { message in
                        showToast(message)
                    }
                }
            }
        }
        .overlay(alignment: .top) {
            if let toast {
                Text(toast)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(ConsumerColors.textDark)
                    .clipShape(Capsule())
                    .padding(.top, 8)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: toast)
        .background(ConsumerColors.bgWarm.ignoresSafeArea())
    }

    private func showToast(_ message: String) {
        toast = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if toast == message { toast = nil }
        }
    }
}

#Preview {
    GhostSetupFlow()
}
