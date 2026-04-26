import SwiftUI

struct CardBack: View {
    let offer: ConsumerOffer

    var body: some View {
        VStack(spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(ConsumerColors.green)
                Text("Spot reserved · \(offer.businessName) · \(offer.shortDeal)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(ConsumerColors.textDark)
                    .lineLimit(2)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(ConsumerColors.bgGreen))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(ConsumerColors.borderGreen, lineWidth: 1))

            Text("Your spot is held for this offer.")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(ConsumerColors.textMid)

            QRGrid(seed: offer.pin, size: 210)

            VStack(spacing: 10) {
                Text("BACKUP PIN")
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(1.4)
                    .foregroundStyle(ConsumerColors.textMuted)
                PinBoxes(pin: offer.pin)
            }

            VStack(spacing: 4) {
                Text("Show this at the counter.")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(ConsumerColors.textDark)
                Text("Single use · Non-transferable")
                    .font(.system(size: 11))
                    .foregroundStyle(ConsumerColors.textMuted)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(RoundedRectangle(cornerRadius: 28).fill(ConsumerColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: 28).strokeBorder(ConsumerColors.borderLight, lineWidth: 1))
        .shadow(color: .black.opacity(0.18), radius: 24, y: 12)
    }
}
