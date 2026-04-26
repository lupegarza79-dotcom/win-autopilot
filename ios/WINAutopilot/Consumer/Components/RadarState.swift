import SwiftUI

struct RadarState: View {
    let topAlertLabel: String
    let onShowBestMatch: () -> Void

    @State private var pulse = false

    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                ForEach(0..<3) { i in
                    Circle()
                        .strokeBorder(
                            i == 1 ? ConsumerColors.aiBlue.opacity(0.45) : ConsumerColors.green.opacity(0.35),
                            lineWidth: 1.5
                        )
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
                    .overlay(Circle().strokeBorder(ConsumerColors.borderGreen, lineWidth: 1))
                VStack(spacing: 2) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(ConsumerColors.aiBlue)
                    Text("WIN")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundStyle(ConsumerColors.green)
                }
            }
            .frame(height: 200)

            VStack(spacing: 6) {
                Text("WIN is scanning for your next match...")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(ConsumerColors.textDark)
                    .multilineTextAlignment(.center)
                Text("Wait for the perfect match or adjust your alerts to see more.")
                    .font(.system(size: 13))
                    .foregroundStyle(ConsumerColors.textMid)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)

            VStack(alignment: .leading, spacing: 8) {
                statusRow(icon: "sparkles", text: topAlertLabel, color: ConsumerColors.aiBlue)
                statusRow(icon: "antenna.radiowaves.left.and.right", text: "Scanning \(BehaviorEngine.totalOfferCount) local offers", color: ConsumerColors.aiBlue)
                statusRow(icon: "location.fill", text: "Checking offers within 1.5 mi", color: ConsumerColors.retailBlue)
                statusRow(icon: "checkmark.seal.fill", text: "Only showing matches above 80%", color: ConsumerColors.green)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: 14).fill(ConsumerColors.bgCard))
            .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(ConsumerColors.borderLight, lineWidth: 1))
            .padding(.horizontal, 24)

            Button(action: onShowBestMatch) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 12, weight: .bold))
                    Text("Show best match now")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(ConsumerColors.textDark)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(Capsule().fill(ConsumerColors.greenNeon))
            }
            .buttonStyle(PressScaleStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { pulse = true }
    }

    private func statusRow(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(color)
                .frame(width: 16)
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(ConsumerColors.textMid)
                .lineLimit(1)
            Spacer(minLength: 0)
        }
    }
}
