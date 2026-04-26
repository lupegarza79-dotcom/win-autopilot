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

            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 6) {
                    Circle().fill(ConsumerColors.greenNeon).frame(width: 6, height: 6)
                    Text("WIN PICKED THIS FOR YOU")
                        .font(.system(size: 10, weight: .heavy))
                        .tracking(1.4)
                        .foregroundStyle(ConsumerColors.greenNeon)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(ConsumerColors.green.opacity(0.12))
                )
                .overlay(
                    Capsule().strokeBorder(ConsumerColors.green.opacity(0.35), lineWidth: 1)
                )

                HStack(spacing: 8) {
                    Text(offer.businessName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(ConsumerColors.textLight)
                    Text("·").foregroundStyle(ConsumerColors.textLightMuted)
                    Text(offer.distance)
                        .font(.system(size: 13))
                        .foregroundStyle(ConsumerColors.textLightMid)
                    Text("·").foregroundStyle(ConsumerColors.textLightMuted)
                    Text(offer.walkTime)
                        .font(.system(size: 13))
                        .foregroundStyle(ConsumerColors.textLightMid)
                }

                Text(offer.dealText)
                    .font(.system(size: 38, weight: .heavy))
                    .foregroundStyle(ConsumerColors.textLight)
                    .lineLimit(3)
                    .minimumScaleFactor(0.7)

                Spacer(minLength: 0)

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
                    HStack(spacing: 5) {
                        Circle().fill(ConsumerColors.greenNeon).frame(width: 5, height: 5)
                        Text("\(offer.matchScore)% match")
                            .font(.system(size: 11, weight: .heavy))
                            .foregroundStyle(ConsumerColors.greenNeon)
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(ConsumerColors.green.opacity(0.14)))
                    .overlay(Capsule().strokeBorder(ConsumerColors.green.opacity(0.35), lineWidth: 1))
                }

                HStack(spacing: 10) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(ConsumerColors.greenNeon)
                    Text(offer.matchReason)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(ConsumerColors.textLight)
                        .lineLimit(2)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(ConsumerColors.green.opacity(0.25), lineWidth: 1)
                )
            }
            .padding(20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.25), radius: 24, y: 12)
    }
}
