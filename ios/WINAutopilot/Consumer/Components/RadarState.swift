import SwiftUI

struct RadarState: View {
    @State private var pulse = false

    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                ForEach(0..<3) { i in
                    Circle()
                        .strokeBorder(ConsumerColors.green.opacity(0.35), lineWidth: 1.5)
                        .frame(width: 180, height: 180)
                        .scaleEffect(pulse ? 1.4 : 0.6)
                        .opacity(pulse ? 0 : 1)
                        .animation(
                            .easeOut(duration: 2.4)
                            .repeatForever(autoreverses: false)
                            .delay(Double(i) * 0.6),
                            value: pulse
                        )
                }
                Circle()
                    .fill(ConsumerColors.bgGreen)
                    .frame(width: 96, height: 96)
                    .overlay(
                        Circle().strokeBorder(ConsumerColors.borderGreen, lineWidth: 1)
                    )
                Text("WIN")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundStyle(ConsumerColors.green)
            }
            .frame(height: 220)

            VStack(spacing: 6) {
                Text("WIN is scanning for your next deal...")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(ConsumerColors.textDark)
                    .multilineTextAlignment(.center)
                Text("We only show deals worth your time.")
                    .font(.system(size: 13))
                    .foregroundStyle(ConsumerColors.textMid)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { pulse = true }
    }
}
