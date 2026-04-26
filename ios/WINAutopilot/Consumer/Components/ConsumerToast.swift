import SwiftUI

struct ConsumerToast: View {
    let message: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(ConsumerColors.green)
            Text(message)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(ConsumerColors.textDark)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Capsule().fill(ConsumerColors.bgCard)
        )
        .overlay(
            Capsule().strokeBorder(ConsumerColors.borderLight, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.10), radius: 16, y: 6)
    }
}
