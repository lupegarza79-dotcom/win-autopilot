import SwiftUI

struct CardFront: View {
    let offer: ConsumerOffer

    private func hex(_ s: String) -> Color {
        var v: UInt64 = 0
        Scanner(string: s.replacingOccurrences(of: "#", with: "")).scanHexInt64(&v)
        let r = Double((v >> 16) & 0xff) / 255
        let g = Double((v >> 8) & 0xff) / 255
        let b = Double(v & 0xff) / 255
        return Color(red: r, green: g, blue: b)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                colors: [hex(offer.gradientStart), hex(offer.gradientEnd)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(alignment: .leading, spacing: 14) {
                DealHeroImage(offer: offer, height: 168)

                HStack(spacing: 8) {
                    Text(offer.businessName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(ConsumerColors.textLight)
                    Text("·").foregroundStyle(ConsumerColors.textLightMuted)
                    Text(offer.distance)
                        .font(.system(size: 12))
                        .foregroundStyle(ConsumerColors.textLightMid)
                    Text("·").foregroundStyle(ConsumerColors.textLightMuted)
                    Text(offer.walkTime)
                        .font(.system(size: 12))
                        .foregroundStyle(ConsumerColors.textLightMid)
                }

                Text(offer.dealText)
                    .font(.system(size: 36, weight: .heavy))
                    .foregroundStyle(ConsumerColors.textLight)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)

                SpotsBar(spotsLeft: offer.spotsLeft, spotsTotal: offer.spotsTotal)

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("EXPIRES IN")
                            .font(.system(size: 9, weight: .heavy))
                            .tracking(1.2)
                            .foregroundStyle(ConsumerColors.textLightMuted)
                        ConsumerCountdownTimer(totalMinutes: offer.countdownMinutes)
                    }
                    Spacer()
                    HStack(spacing: 4) {
                        Text("\(offer.matchScore)% match")
                            .font(.system(size: 11, weight: .heavy))
                            .foregroundStyle(ConsumerColors.greenNeon)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(ConsumerColors.green.opacity(0.14)))
                    .overlay(Capsule().strokeBorder(ConsumerColors.green.opacity(0.35), lineWidth: 1))
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(ConsumerColors.aiBlue)
                        Text("WHY THIS MATCHED")
                            .font(.system(size: 9, weight: .heavy))
                            .tracking(1.3)
                            .foregroundStyle(ConsumerColors.aiBlue)
                    }
                    Text(offer.matchReason)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(ConsumerColors.textLight)
                        .lineLimit(2)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12).fill(ConsumerColors.aiBlueSoft))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(ConsumerColors.aiBlueBorder, lineWidth: 1))
            }
            .padding(18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.25), radius: 24, y: 12)
    }
}
