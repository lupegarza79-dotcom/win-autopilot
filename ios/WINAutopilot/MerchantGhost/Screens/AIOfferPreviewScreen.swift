import SwiftUI

struct AIOfferPreviewScreen: View {
    @Bindable var store: GhostStore
    let onToast: (String) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: ConsumerSpacing.md) {
                GhostHeader(
                    step: 4, total: 5,
                    title: "WIN created 3 offers",
                    subtitle: "Pick the ones to send to the Consumer Matchmaker."
                )

                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .foregroundStyle(ConsumerColors.aiBlue)
                    Text("Generated from your inventory, slow hours and margin guard.")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(ConsumerColors.textMid)
                }
                .padding(.horizontal, ConsumerSpacing.screen)
                .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(store.generatedDrafts) { offer in
                    OfferDraftCard(
                        offer: offer,
                        sent: store.sentOfferIds.contains(offer.id)
                    ) {
                        store.sendToConsumerMatchmaker(offer)
                        onToast("Offer supply created. Consumer Matchmaker can route this next.")
                    }
                    .padding(.horizontal, ConsumerSpacing.screen)
                }

                if store.generatedDrafts.isEmpty {
                    GhostCard {
                        Text("No drafts yet. Go back and add at least one product and slow window.")
                            .font(.system(size: 13))
                            .foregroundStyle(ConsumerColors.textMid)
                    }
                    .padding(.horizontal, ConsumerSpacing.screen)
                }

                if !store.sentOfferIds.isEmpty {
                    GhostCard {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(ConsumerColors.green)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(store.sentOfferIds.count) offer\(store.sentOfferIds.count == 1 ? "" : "s") in supply")
                                    .font(.system(size: 14, weight: .heavy))
                                    .foregroundStyle(ConsumerColors.textDark)
                                Text("Consumer Matchmaker can route these to the right users.")
                                    .font(.system(size: 12))
                                    .foregroundStyle(ConsumerColors.textMid)
                            }
                        }
                    }
                    .padding(.horizontal, ConsumerSpacing.screen)
                }

                Spacer(minLength: 24)
            }
        }
        .background(ConsumerColors.bgWarm)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct OfferDraftCard: View {
    let offer: GhostOffer
    let sent: Bool
    let onSend: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Circle()
                    .fill(kindColor)
                    .frame(width: 6, height: 6)
                Text(offer.kind.rawValue.uppercased())
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(0.8)
                    .foregroundStyle(kindColor)
                Spacer()
                if sent {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Sent")
                    }
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundStyle(ConsumerColors.green)
                }
            }

            Text(offer.title)
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(ConsumerColors.textDark)

            Text(offer.description)
                .font(.system(size: 13))
                .foregroundStyle(ConsumerColors.textMid)

            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(ConsumerColors.aiBlue)
                Text(offer.reason)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(ConsumerColors.textDark)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(10)
            .background(ConsumerColors.aiBlueSoft)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(ConsumerColors.aiBlueBorder, lineWidth: 1)
            )
            .clipShape(.rect(cornerRadius: 10))

            HStack(spacing: 10) {
                statPill(icon: "person.2.fill", label: "Cap", value: "\(offer.cap)")
                statPill(icon: "timer", label: "Window", value: "\(offer.expiresInMinutes)m")
                statPill(icon: "dollarsign.circle.fill", label: "Sales", value: "$\(offer.estimatedSalesMin)–$\(offer.estimatedSalesMax)")
            }

            if offer.pickupOnly {
                HStack(spacing: 6) {
                    Image(systemName: "bag.fill")
                    Text("Pickup only")
                }
                .font(.system(size: 11, weight: .heavy))
                .foregroundStyle(ConsumerColors.retailBlue)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(ConsumerColors.retailBlueSoft)
                .clipShape(Capsule())
            }

            Button(action: onSend) {
                Text(sent ? "Sent to Consumer Matchmaker" : "Send to Consumer Matchmaker")
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(sent ? ConsumerColors.green.opacity(0.4) : ConsumerColors.green)
                    .clipShape(.rect(cornerRadius: ConsumerSpacing.radiusBtn))
            }
            .disabled(sent)
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

    private var kindColor: Color {
        switch offer.kind {
        case .traffic: return ConsumerColors.green
        case .marginSafe: return ConsumerColors.aiBlue
        case .groupPack: return ConsumerColors.retailBlue
        }
    }

    private func statPill(icon: String, label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .bold))
                Text(label.uppercased())
                    .font(.system(size: 9, weight: .heavy))
                    .tracking(0.6)
            }
            .foregroundStyle(ConsumerColors.textMid)
            Text(value)
                .font(.system(size: 13, weight: .heavy))
                .foregroundStyle(ConsumerColors.textDark)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(ConsumerColors.bgWarm)
        .clipShape(.rect(cornerRadius: 10))
    }
}
