import SwiftUI

struct BusinessSnapshotScreen: View {
    @Bindable var store: GhostStore
    let onContinue: () -> Void

    var canContinue: Bool {
        !store.merchant.name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !store.merchant.address.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(spacing: ConsumerSpacing.md) {
                GhostHeader(
                    step: 0, total: 5,
                    title: "Tell WIN who you are",
                    subtitle: "The engine will do the campaign work."
                )

                GhostCard {
                    GhostField(label: "BUSINESS NAME", text: $store.merchant.name, placeholder: "Don Pepe Tacos")

                    VStack(alignment: .leading, spacing: 6) {
                        Text("CATEGORY")
                            .font(.system(size: 11, weight: .heavy))
                            .tracking(0.6)
                            .foregroundStyle(ConsumerColors.textMid)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(MerchantCategory.allCases) { cat in
                                    GhostTagChip(
                                        label: cat.rawValue,
                                        selected: store.merchant.category == cat
                                    ) {
                                        store.merchant.category = cat
                                    }
                                }
                            }
                        }
                        .contentMargins(.horizontal, 0)
                    }

                    GhostField(label: "ADDRESS / CITY", text: $store.merchant.address, placeholder: "McAllen, TX")
                    GhostField(label: "OPERATING HOURS", text: $store.merchant.hours, placeholder: "Mon–Sun · 11 AM – 9 PM")
                    GhostField(label: "WHATSAPP", text: $store.merchant.whatsapp, placeholder: "9565550188", keyboard: .phonePad)
                }
                .padding(.horizontal, ConsumerSpacing.screen)

                GhostCard {
                    HStack(spacing: 10) {
                        Image(systemName: "sparkles")
                            .foregroundStyle(ConsumerColors.aiBlue)
                        Text("WIN only needs the basics. AI fills in the rest.")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(ConsumerColors.textMid)
                    }
                }
                .padding(.horizontal, ConsumerSpacing.screen)

                Spacer(minLength: 12)

                GhostPrimaryButton(title: "Continue to Products", enabled: canContinue) {
                    store.saveMerchant()
                    onContinue()
                }

                Spacer(minLength: 24)
            }
        }
        .background(ConsumerColors.bgWarm)
        .navigationBarTitleDisplayMode(.inline)
    }
}
