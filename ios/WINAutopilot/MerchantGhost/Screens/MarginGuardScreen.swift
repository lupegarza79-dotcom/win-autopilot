import SwiftUI

struct MarginGuardScreen: View {
    @Bindable var store: GhostStore
    let onGenerate: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: ConsumerSpacing.md) {
                GhostHeader(
                    step: 3, total: 5,
                    title: "Set your limits",
                    subtitle: "WIN will not create offers outside your margin guard."
                )

                GhostCard {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("MAX DISCOUNT")
                                .font(.system(size: 11, weight: .heavy))
                                .tracking(0.6)
                                .foregroundStyle(ConsumerColors.textMid)
                            Spacer()
                            Text("\(store.marginGuard.maxDiscountPct)%")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundStyle(ConsumerColors.green)
                        }
                        Slider(
                            value: Binding(
                                get: { Double(store.marginGuard.maxDiscountPct) },
                                set: { store.marginGuard.maxDiscountPct = Int($0) }
                            ),
                            in: 5...50,
                            step: 5
                        )
                        .tint(ConsumerColors.green)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("MAX REDEMPTIONS")
                                .font(.system(size: 11, weight: .heavy))
                                .tracking(0.6)
                                .foregroundStyle(ConsumerColors.textMid)
                            Spacer()
                            Text("\(store.marginGuard.maxRedemptions)")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundStyle(ConsumerColors.green)
                        }
                        Slider(
                            value: Binding(
                                get: { Double(store.marginGuard.maxRedemptions) },
                                set: { store.marginGuard.maxRedemptions = Int($0) }
                            ),
                            in: 5...100,
                            step: 5
                        )
                        .tint(ConsumerColors.green)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("MIN PURCHASE ($)")
                            .font(.system(size: 11, weight: .heavy))
                            .tracking(0.6)
                            .foregroundStyle(ConsumerColors.textMid)
                        TextField("0", value: $store.marginGuard.minPurchase, format: .number)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(ConsumerColors.textDark)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 14)
                            .background(ConsumerColors.bgCard)
                            .overlay(
                                RoundedRectangle(cornerRadius: ConsumerSpacing.radiusBtn)
                                    .strokeBorder(ConsumerColors.borderMid, lineWidth: 1)
                            )
                    }

                    Toggle(isOn: $store.marginGuard.pickupOnly) {
                        Text("Pickup only")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(ConsumerColors.textDark)
                    }
                    .tint(ConsumerColors.green)

                    Toggle(isOn: $store.marginGuard.active) {
                        Text("Margin guard active")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(ConsumerColors.textDark)
                    }
                    .tint(ConsumerColors.green)
                }
                .padding(.horizontal, ConsumerSpacing.screen)

                GhostCard {
                    HStack(spacing: 10) {
                        Image(systemName: "shield.lefthalf.filled")
                            .foregroundStyle(ConsumerColors.retailBlue)
                        Text("WIN will never exceed these limits when generating offers.")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(ConsumerColors.textMid)
                    }
                }
                .padding(.horizontal, ConsumerSpacing.screen)

                Spacer(minLength: 12)

                GhostPrimaryButton(title: "Generate AI Offers") {
                    store.saveMarginGuard()
                    onGenerate()
                }

                Spacer(minLength: 24)
            }
        }
        .background(ConsumerColors.bgWarm)
        .navigationBarTitleDisplayMode(.inline)
    }
}
