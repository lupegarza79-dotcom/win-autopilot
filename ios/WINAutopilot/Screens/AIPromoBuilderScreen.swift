import SwiftUI
import UIKit

struct AIPromoBuilderScreen: View {
    @Environment(AppState.self) private var state
    var switchTab: (AppTab) -> Void

    @State private var titleEdit: String = ""
    @State private var timeWindow: String = ""
    @State private var maxRedemptions: String = ""
    @State private var terms: String = ""
    @State private var rewardType: RewardType = .percent_off
    @State private var loaded = false
    @State private var launched = false

    var body: some View {
        ZStack {
            AppColors.bgMain.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    ScreenHeader(
                        title: "AI Promo Builder",
                        subtitle: "One click creates the offer, message, QR and tracking link.",
                        rightLabel: "Step 2 / 5"
                    )

                    recommendationCard

                    editableCard

                    if launched {
                        successCard
                    }

                    VStack(spacing: 10) {
                        PrimaryButton(title: launched ? "Promo Live" : "Launch Promo", icon: "paperplane.fill", disabled: launched) {
                            launch()
                        }
                        HStack(spacing: 10) {
                            SecondaryButton(title: "Regenerate", icon: "arrow.triangle.2.circlepath") {
                                regenerate()
                            }
                            SecondaryButton(title: "Copy Message", icon: "doc.on.doc") {
                                UIPasteboard.general.string = state.offer.whatsappMessage
                                EventTracker.track(.OFFER_SHARED)
                                state.showToast("Offer copied.")
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.screenPadding)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            if !loaded {
                syncFromState()
                loaded = true
            }
        }
    }

    private var recommendationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles").foregroundStyle(AppColors.neonGreen)
                    Text("AI RECOMMENDATION")
                        .font(AppFont.body(10, weight: .heavy))
                        .tracking(1.5)
                        .foregroundStyle(AppColors.neonGreen)
                }
                Spacer()
                CountdownBadge(minutesLeft: state.offer.countdownMinutes)
            }

            Text(state.offer.title)
                .font(AppFont.display(24, weight: .heavy))
                .foregroundStyle(AppColors.textWhite)

            Text(state.offer.description)
                .font(AppFont.body(14, weight: .regular))
                .foregroundStyle(AppColors.textMuted)
                .lineSpacing(2)

            Divider().background(AppColors.border)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "brain.head.profile").foregroundStyle(AppColors.neonBlue)
                    Text("Why AI picked this")
                        .font(AppFont.body(11, weight: .heavy))
                        .tracking(1)
                        .foregroundStyle(AppColors.neonBlue)
                }
                Text(state.offer.whyAIPicked)
                    .font(AppFont.body(13, weight: .regular))
                    .foregroundStyle(AppColors.textWhite.opacity(0.85))
                    .lineSpacing(2)
            }

            HStack(spacing: 10) {
                metric(icon: "dollarsign.circle.fill", label: "Est. sales", value: "$\(state.offer.estimatedSalesMin)–$\(state.offer.estimatedSalesMax)", color: AppColors.neonGreen)
                metric(icon: "person.2.fill", label: "Cap", value: "\(state.offer.maxRedemptions)", color: AppColors.neonBlue)
            }
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Spacing.radius).fill(AppColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: Spacing.radius).stroke(AppColors.neonGreen.opacity(0.25), lineWidth: 1))
    }

    private func metric(icon: String, label: String, value: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).foregroundStyle(color)
            VStack(alignment: .leading, spacing: 1) {
                Text(value).font(AppFont.body(14, weight: .heavy)).foregroundStyle(AppColors.textWhite)
                Text(label).font(AppFont.body(10, weight: .medium)).foregroundStyle(AppColors.textMuted)
            }
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.bgDeep))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.border, lineWidth: 1))
    }

    private var editableCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("CUSTOMIZE")
                .font(AppFont.body(10, weight: .heavy))
                .tracking(1.5)
                .foregroundStyle(AppColors.textMuted)

            editField("Title", text: $titleEdit)
            RewardTypePicker(selection: $rewardType)
            editField("Time window", text: $timeWindow)
            editField("Max redemptions", text: $maxRedemptions, keyboard: .numberPad)
            editFieldMulti("Terms", text: $terms)
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Spacing.radius).fill(AppColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: Spacing.radius).stroke(AppColors.border, lineWidth: 1))
    }

    private func editField(_ label: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(AppFont.body(11, weight: .semibold))
                .tracking(0.8)
                .foregroundStyle(AppColors.textMuted)
            TextField("", text: text)
                .keyboardType(keyboard)
                .foregroundStyle(AppColors.textWhite)
                .font(AppFont.body(15, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.bgDeep))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.border, lineWidth: 1))
        }
    }

    private func editFieldMulti(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(AppFont.body(11, weight: .semibold))
                .tracking(0.8)
                .foregroundStyle(AppColors.textMuted)
            TextEditor(text: text)
                .scrollContentBackground(.hidden)
                .foregroundStyle(AppColors.textWhite)
                .font(AppFont.body(13, weight: .regular))
                .frame(minHeight: 70)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.bgDeep))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.border, lineWidth: 1))
        }
    }

    private var successCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "checkmark.seal.fill").foregroundStyle(AppColors.neonGreen)
                Text("LIVE — PUBLIC LINK")
                    .font(AppFont.body(10, weight: .heavy))
                    .tracking(1.5)
                    .foregroundStyle(AppColors.neonGreen)
            }
            Text(state.offer.publicLink)
                .font(AppFont.mono(14, weight: .bold))
                .foregroundStyle(AppColors.textWhite)
            Text("Share this link with customers. They tap, reserve, and get a QR/PIN.")
                .font(AppFont.body(12, weight: .regular))
                .foregroundStyle(AppColors.textMuted)
            HStack(spacing: 10) {
                SecondaryButton(title: "View Public Offer", icon: "eye.fill") {
                    switchTab(.offer)
                }
                SecondaryButton(title: "Copy Link", icon: "link") {
                    UIPasteboard.general.string = state.offer.publicLink
                    state.showToast("Offer copied.")
                }
            }
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Spacing.radius).fill(AppColors.neonGreen.opacity(0.08)))
        .overlay(RoundedRectangle(cornerRadius: Spacing.radius).stroke(AppColors.neonGreen.opacity(0.45), lineWidth: 1))
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    private func syncFromState() {
        titleEdit = state.offer.title
        timeWindow = state.offer.timeWindow
        maxRedemptions = "\(state.offer.maxRedemptions)"
        terms = state.offer.terms
        rewardType = state.offer.type
    }

    private func regenerate() {
        let p = AIEngine.regeneratePromo(business: state.business)
        state.applyGenerated(p)
        EventTracker.track(.OFFER_REGENERATED)
        syncFromState()
        state.showToast("New promo generated.")
    }

    private func launch() {
        state.offer.title = titleEdit
        state.offer.timeWindow = timeWindow
        state.offer.maxRedemptions = Int(maxRedemptions) ?? state.offer.maxRedemptions
        state.offer.spotsLeft = state.offer.maxRedemptions
        state.offer.terms = terms
        state.offer.type = rewardType
        state.hasLaunchedOffer = true

        EventTracker.track(.OFFER_LAUNCHED)
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            launched = true
        }
        state.showToast("Promo launched.")
    }
}
