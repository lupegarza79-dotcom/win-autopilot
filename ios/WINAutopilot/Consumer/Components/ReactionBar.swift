import SwiftUI

struct ReactionBar: View {
    let onPass: () -> Void
    let onClaim: () -> Void
    let onRemind: () -> Void
    var disabled: Bool = false

    var body: some View {
        HStack(spacing: 18) {
            ReactionButton(
                icon: "xmark",
                size: 60,
                bg: ConsumerColors.bgCard,
                fg: Color(red: 0.86, green: 0.20, blue: 0.27),
                border: ConsumerColors.borderMid,
                action: onPass
            )

            Button(action: onClaim) {
                ZStack {
                    Circle()
                        .fill(ConsumerColors.textDark)
                        .frame(width: 88, height: 88)
                    Circle()
                        .strokeBorder(ConsumerColors.greenNeon, lineWidth: 2)
                        .frame(width: 88, height: 88)
                    VStack(spacing: 2) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(ConsumerColors.greenNeon)
                        Text("CLAIM")
                            .font(.system(size: 10, weight: .heavy))
                            .tracking(1.4)
                            .foregroundStyle(ConsumerColors.textLight)
                    }
                }
                .shadow(color: ConsumerColors.green.opacity(0.4), radius: 18, y: 8)
            }
            .buttonStyle(PressScaleStyle())
            .disabled(disabled)

            ReactionButton(
                icon: "clock.fill",
                size: 60,
                bg: ConsumerColors.bgCard,
                fg: ConsumerColors.amber,
                border: ConsumerColors.borderMid,
                action: onRemind
            )
        }
        .opacity(disabled ? 0.5 : 1)
    }
}

private struct ReactionButton: View {
    let icon: String
    let size: CGFloat
    let bg: Color
    let fg: Color
    let border: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle().fill(bg)
                Circle().strokeBorder(border, lineWidth: 1)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(fg)
            }
            .frame(width: size, height: size)
            .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
        }
        .buttonStyle(PressScaleStyle())
    }
}

struct PressScaleStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
