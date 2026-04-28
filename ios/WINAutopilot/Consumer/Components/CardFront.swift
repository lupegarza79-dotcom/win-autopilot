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
                DealHeroImage(offer: offer, height: 170)

                HStack(spacing: 6) {
                    Circle().fill(ConsumerColors.greenNeon).frame(width: 6, height: 6)
                    Text("WIN PICKED THIS FOR YOU")
                        .font(.system(size: 10, weight: .heavy))
                        .tracking(1.4)
                        .foregroundStyle(ConsumerColors.greenNeon)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Capsule().fill(ConsumerColors.green.opacity(0.12)))
                .overlay(Capsule().strokeBorder(ConsumerColors.green.opacity(0.35), lineWidth: 1))

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
                    .minimumScaleFactor(0.75)
                    .padding(.horizontal, 2)

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
                        Circle()
                            .fill(ConsumerColors.greenNeon)
                            .frame(width: 4, height: 4)
                        Text("\(offer.matchScore)% match")
                            .font(.system(size: 10, weight: .heavy))
                            .foregroundStyle(ConsumerColors.greenNeon)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(ConsumerColors.green.opacity(0.12)))
                    .overlay(Capsule().strokeBorder(ConsumerColors.green.opacity(0.3), lineWidth: 1))
                }

                HStack(spacing: 10) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(ConsumerColors.aiBlue)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("WHY THIS MATCHED")
                            .font(.system(size: 8, weight: .heavy))
                            .tracking(0.8)
                            .foregroundStyle(ConsumerColors.aiBlue)
                        Text(offer.matchReason)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(ConsumerColors.textLight)
                            .lineLimit(2)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 11)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12).fill(ConsumerColors.aiBlueSoft))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(ConsumerColors.aiBlueBorder, lineWidth: 1))
                .padding(.bottom, 2)
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
