import SwiftUI

struct ToastView: View {
    let text: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(AppColors.neonGreen)
            Text(text)
                .font(AppFont.body(14, weight: .semibold))
                .foregroundStyle(AppColors.textWhite)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Capsule().fill(AppColors.bgCard)
        )
        .overlay(Capsule().stroke(AppColors.neonGreen.opacity(0.5), lineWidth: 1))
        .shadow(color: .black.opacity(0.4), radius: 16, y: 6)
    }
}

struct ToastOverlay: ViewModifier {
    @Environment(AppState.self) private var state

    func body(content: Content) -> some View {
        content.overlay(alignment: .top) {
            if let toast = state.toast {
                ToastView(text: toast.text)
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .id(toast.id)
                    .allowsHitTesting(false)
            }
        }
    }
}

extension View {
    func withToast() -> some View { modifier(ToastOverlay()) }
}
