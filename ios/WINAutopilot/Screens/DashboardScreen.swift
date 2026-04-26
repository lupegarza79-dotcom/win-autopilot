import SwiftUI

struct DashboardScreen: View {
    @Environment(AppState.self) private var state
    @State private var hasTrackedInsight = false

    private let cols = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        ZStack {
            AppColors.bgMain.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    ScreenHeader(
                        title: "Today's Campaign",
                        subtitle: "Know what worked. Improve the next promo.",
                        rightLabel: "Step 5 / 5"
                    )

                    LazyVGrid(columns: cols, spacing: 12) {
                        StatCard(value: "\(state.stats.views)", label: "Views", icon: "eye.fill")
                        StatCard(value: "\(state.stats.shares)", label: "Shares", accent: AppColors.neonBlue, icon: "square.and.arrow.up")
                        StatCard(value: "\(state.stats.going)", label: "I'm Going", accent: AppColors.neonGreen, icon: "hand.raised.fill")
                        StatCard(value: "\(state.stats.redeemed)", label: "Redeemed", accent: AppColors.neonGreen, icon: "checkmark.seal.fill")
                        StatCard(value: "$\(Int(state.stats.estimatedSales))", label: "Estimated sales", accent: AppColors.neonGreen, icon: "dollarsign.circle.fill")
                        StatCard(value: "$\(Int(state.stats.averageTicket))", label: "Avg ticket", icon: "cart.fill")
                        StatCard(value: "\(state.stats.noShows)", label: "No-shows", accent: AppColors.amber, icon: "xmark.circle.fill")
                        StatCard(value: String(format: "$%.2f", state.stats.winFee), label: "WIN fee est.", accent: AppColors.textMuted, icon: "percent")
                    }

                    insightCard

                    VStack(spacing: 10) {
                        PrimaryButton(title: "Run Similar Promo Tomorrow", icon: "arrow.clockwise") {
                            state.showToast("Promo scheduled for tomorrow.")
                            EventTracker.track(.OFFER_SCHEDULED)
                        }
                        SecondaryButton(title: "Create Better Promo", icon: "wand.and.stars") {
                            let p = AIEngine.regeneratePromo(business: state.business)
                            state.applyGenerated(p)
                            EventTracker.track(.OFFER_REGENERATED)
                            state.showToast("New promo generated.")
                        }
                        SecondaryButton(title: "Export Pilot Report", icon: "square.and.arrow.down") {
                            state.showToast("Pilot report generated.")
                        }
                    }

                    footer
                }
                .padding(.horizontal, Spacing.screenPadding)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            if !hasTrackedInsight {
                hasTrackedInsight = true
                EventTracker.track(.AI_RECOMMENDATION_CREATED)
            }
        }
    }

    private var insightCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "brain.head.profile")
                    .foregroundStyle(AppColors.neonBlue)
                Text("AI INSIGHT")
                    .font(AppFont.body(10, weight: .heavy))
                    .tracking(1.5)
                    .foregroundStyle(AppColors.neonBlue)
            }
            Text(AIEngine.generateInsight(stats: state.stats))
                .font(AppFont.body(14, weight: .medium))
                .foregroundStyle(AppColors.textWhite)
                .lineSpacing(3)
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Spacing.radius).fill(AppColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: Spacing.radius).stroke(AppColors.neonBlue.opacity(0.35), lineWidth: 1))
    }

    private var footer: some View {
        VStack(spacing: 4) {
            Text("Data is the product. Every campaign makes WIN smarter.")
                .font(AppFont.body(12, weight: .semibold))
                .foregroundStyle(AppColors.textWhite)
                .multilineTextAlignment(.center)
            Text("Only pay when WIN brings results.")
                .font(AppFont.body(11, weight: .medium))
                .foregroundStyle(AppColors.textHint)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }
}
