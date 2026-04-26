import SwiftUI

struct QRPinBlock: View {
    let pin: String
    var seed: String = "WIN"

    var body: some View {
        VStack(spacing: 14) {
            FakeQR(seed: seed, size: 180)
            VStack(spacing: 4) {
                Text("PIN")
                    .font(AppFont.body(11, weight: .semibold))
                    .tracking(2)
                    .foregroundStyle(AppColors.textMuted)
                Text(pin)
                    .font(AppFont.mono(28, weight: .heavy))
                    .foregroundStyle(AppColors.textWhite)
                    .monospacedDigit()
            }
            Text("Show this QR/PIN at the counter.")
                .font(AppFont.body(13, weight: .medium))
                .foregroundStyle(AppColors.textMuted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.lg)
        .background(RoundedRectangle(cornerRadius: Spacing.radius).fill(AppColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: Spacing.radius).stroke(AppColors.neonGreen.opacity(0.4), lineWidth: 1))
    }
}
