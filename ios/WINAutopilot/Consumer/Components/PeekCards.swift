import SwiftUI

struct PeekCards: View {
    let offers: [ConsumerOffer]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("WAITING FOR YOU")
                    .font(.system(size: 9, weight: .heavy))
                    .tracking(1.4)
                    .foregroundStyle(ConsumerColors.textMuted)
                Spacer()
                Text("\(offers.count) more")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(ConsumerColors.textMuted)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(offers) { offer in
                        PeekCard(offer: offer)
                    }
                }
                .padding(.horizontal, 16)
            }
            .scrollClipDisabled()
            .padding(.horizontal, -16)
        }
    }
}

private struct PeekCard: View {
    let offer: ConsumerOffer

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(offer.category.emoji)
                    .font(.system(size: 18))
                Spacer()
                Text("\(offer.matchScore)%")
                    .font(.system(size: 10, weight: .heavy))
                    .foregroundStyle(ConsumerColors.green)
            }
            Text(offer.shortDeal)
                .font(.system(size: 14, weight: .heavy))
                .foregroundStyle(ConsumerColors.textDark)
                .lineLimit(1)
            Text(offer.distance)
                .font(.system(size: 11))
                .foregroundStyle(ConsumerColors.textMuted)
        }
        .padding(12)
        .frame(width: 130, height: 88, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(ConsumerColors.bgCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(ConsumerColors.borderLight, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
    }
}
