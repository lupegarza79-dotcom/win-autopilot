import SwiftUI

struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    var disabled: Bool = false
    let action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button {
            guard !disabled else { return }
            action()
        } label: {
            HStack(spacing: 8) {
                if let icon { Image(systemName: icon) }
                Text(title)
                    .font(AppFont.body(16, weight: .bold))
            }
            .foregroundStyle(disabled ? AppColors.textMuted : Color.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: Spacing.radiusBtn)
                    .fill(disabled ? AppColors.bgCard : AppColors.neonGreen)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Spacing.radiusBtn)
                    .stroke(disabled ? AppColors.border : Color.clear, lineWidth: 1)
            )
            .scaleEffect(pressed ? 0.97 : 1)
            .shadow(color: disabled ? .clear : AppColors.neonGreen.opacity(0.25), radius: 12, y: 4)
        }
        .buttonStyle(.plain)
        .disabled(disabled)
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in withAnimation(.easeOut(duration: 0.12)) { pressed = true } }
            .onEnded { _ in withAnimation(.easeOut(duration: 0.18)) { pressed = false } }
        )
    }
}

struct SecondaryButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon { Image(systemName: icon) }
                Text(title)
                    .font(AppFont.body(15, weight: .semibold))
            }
            .foregroundStyle(AppColors.neonGreen)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: Spacing.radiusBtn)
                    .fill(Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Spacing.radiusBtn)
                    .stroke(AppColors.neonGreen.opacity(0.6), lineWidth: 1.2)
            )
            .scaleEffect(pressed ? 0.97 : 1)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in withAnimation(.easeOut(duration: 0.12)) { pressed = true } }
            .onEnded { _ in withAnimation(.easeOut(duration: 0.18)) { pressed = false } }
        )
    }
}
