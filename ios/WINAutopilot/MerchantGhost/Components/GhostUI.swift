import SwiftUI

struct GhostHeader: View {
    let step: Int
    let total: Int
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                ForEach(0..<total, id: \.self) { i in
                    Capsule()
                        .fill(i <= step ? ConsumerColors.green : ConsumerColors.borderMid)
                        .frame(height: 4)
                }
            }
            HStack(spacing: 8) {
                Text("STEP \(step + 1) OF \(total)")
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(0.8)
                    .foregroundStyle(ConsumerColors.green)
                Text("•")
                    .foregroundStyle(ConsumerColors.textHint)
                Text("Ghost Setup")
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(0.8)
                    .foregroundStyle(ConsumerColors.aiBlue)
            }
            .padding(.top, 4)
            Text(title)
                .font(.system(size: 26, weight: .heavy))
                .foregroundStyle(ConsumerColors.textDark)
            Text(subtitle)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(ConsumerColors.textMid)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, ConsumerSpacing.screen)
        .padding(.top, ConsumerSpacing.md)
        .padding(.bottom, ConsumerSpacing.sm)
    }
}

struct GhostPrimaryButton: View {
    let title: String
    var enabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .heavy))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(enabled ? ConsumerColors.green : ConsumerColors.green.opacity(0.4))
                .clipShape(.rect(cornerRadius: ConsumerSpacing.radiusBtn))
        }
        .disabled(!enabled)
        .padding(.horizontal, ConsumerSpacing.screen)
    }
}

struct GhostSecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(ConsumerColors.textDark)
                .frame(maxWidth: .infinity)
                .frame(height: 46)
                .overlay(
                    RoundedRectangle(cornerRadius: ConsumerSpacing.radiusBtn)
                        .strokeBorder(ConsumerColors.borderMid, lineWidth: 1)
                )
        }
    }
}

struct GhostField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboard: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .heavy))
                .tracking(0.6)
                .foregroundStyle(ConsumerColors.textMid)
            TextField(placeholder, text: $text)
                .keyboardType(keyboard)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(ConsumerColors.textDark)
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(ConsumerColors.bgCard)
                .overlay(
                    RoundedRectangle(cornerRadius: ConsumerSpacing.radiusBtn)
                        .strokeBorder(ConsumerColors.borderMid, lineWidth: 1)
                )
        }
    }
}

struct GhostCard<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ConsumerColors.bgCard)
        .clipShape(.rect(cornerRadius: ConsumerSpacing.radius))
        .overlay(
            RoundedRectangle(cornerRadius: ConsumerSpacing.radius)
                .strokeBorder(ConsumerColors.borderLight, lineWidth: 1)
        )
    }
}

struct GhostTagChip: View {
    let label: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(selected ? .black : ConsumerColors.textDark)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(selected ? ConsumerColors.green : ConsumerColors.bgCard)
                .clipShape(Capsule())
                .overlay(
                    Capsule().strokeBorder(
                        selected ? ConsumerColors.green : ConsumerColors.borderMid,
                        lineWidth: 1
                    )
                )
        }
    }
}
