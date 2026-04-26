import SwiftUI
import UIKit

struct PublicOfferScreen: View {
    @Environment(AppState.self) private var state
    @State private var reserved = false
    @State private var reminderSet = false
    @State private var hasTrackedView = false
    @State private var showingUpcoming = false

    var body: some View {
        ZStack {
            AppColors.bgMain.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    statePicker

                    let offer = currentOffer
                    offerCard(offer: offer)

                    if offer.status == .now {
                        CountdownTimer(totalMinutes: offer.countdownMinutes)
                    }

                    if reserved && offer.status == .now {
                        VStack(spacing: 12) {
                            Text("Your spot is reserved.")
                                .font(AppFont.body(15, weight: .heavy))
                                .foregroundStyle(AppColors.neonGreen)
                            QRPinBlock(pin: offer.pin, seed: offer.id)
                        }
                        .frame(maxWidth: .infinity)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    actionButton(offer: offer)

                    SecondaryButton(title: "Share this offer", icon: "square.and.arrow.up") {
                        UIPasteboard.general.string = offer.whatsappMessage
                        state.stats.shares += 1
                        EventTracker.track(.OFFER_SHARED)
                        state.showToast("Offer copied.")
                    }

                    termsCard(offer: offer)

                    if offer.status == .now {
                        groupPackCard
                    }

                    Text("No ads. Only rewards.")
                        .font(AppFont.body(11, weight: .medium))
                        .foregroundStyle(AppColors.textHint)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal, Spacing.screenPadding)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            guard !hasTrackedView else { return }
            hasTrackedView = true
            state.stats.views += 1
            EventTracker.track(.OFFER_VIEWED)
            if let dist = Double(state.offer.distance.replacingOccurrences(of: " mi", with: "")), dist < 1.5 {
                EventTracker.track(.NEARBY_OFFER_VIEWED)
            }
        }
    }

    private var currentOffer: Offer {
        showingUpcoming ? state.upcomingOffer : state.offer
    }

    private var statePicker: some View {
        HStack(spacing: 8) {
            pill(label: "Live Now", active: !showingUpcoming) { showingUpcoming = false }
            pill(label: "Upcoming", active: showingUpcoming) {
                showingUpcoming = true
                EventTracker.track(.UPCOMING_OFFER_VIEWED)
            }
            Spacer()
        }
    }

    private func pill(label: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(AppFont.body(12, weight: .bold))
                .foregroundStyle(active ? Color.black : AppColors.textWhite)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Capsule().fill(active ? AppColors.neonGreen : AppColors.bgCard))
                .overlay(Capsule().stroke(active ? Color.clear : AppColors.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func offerCard(offer: Offer) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(state.business.name)
                        .font(AppFont.body(13, weight: .semibold))
                        .foregroundStyle(AppColors.textMuted)
                    Text(state.business.category)
                        .font(AppFont.body(11, weight: .regular))
                        .foregroundStyle(AppColors.textHint)
                }
                Spacer()
                OfferStateBadge(status: offer.status)
            }

            Text(offer.title)
                .font(AppFont.display(26, weight: .heavy))
                .foregroundStyle(AppColors.textWhite)

            Text(offer.description)
                .font(AppFont.body(14, weight: .regular))
                .foregroundStyle(AppColors.textMuted)
                .lineSpacing(2)

            HStack(spacing: 10) {
                infoChip(icon: "clock.fill", text: "\(offer.startsAt) – \(offer.endsAt)", color: AppColors.neonBlue)
                infoChip(icon: "location.fill", text: "\(offer.distance) • \(offer.proximityLabel)", color: AppColors.neonGreen)
            }

            if offer.status == .now {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill").foregroundStyle(AppColors.amber)
                    Text("Only \(offer.spotsLeft) of \(offer.maxRedemptions) spots left")
                        .font(AppFont.body(13, weight: .bold))
                        .foregroundStyle(AppColors.textWhite)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.amber.opacity(0.1)))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.amber.opacity(0.4), lineWidth: 1))
            }
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Spacing.radius).fill(AppColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: Spacing.radius).stroke(AppColors.border, lineWidth: 1))
    }

    private func infoChip(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon).foregroundStyle(color).font(.system(size: 11, weight: .bold))
            Text(text)
                .font(AppFont.body(11, weight: .semibold))
                .foregroundStyle(AppColors.textWhite)
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(AppColors.bgDeep))
        .overlay(Capsule().stroke(AppColors.border, lineWidth: 1))
    }

    @ViewBuilder
    private func actionButton(offer: Offer) -> some View {
        switch offer.status {
        case .now:
            PrimaryButton(title: reserved ? "Spot Reserved" : "I'm Going", icon: reserved ? "checkmark.circle.fill" : "hand.raised.fill", disabled: reserved || offer.spotsLeft == 0) {
                state.reserveSpot()
                EventTracker.track(.INTENT_RESERVED)
                EventTracker.track(.QR_GENERATED)
                withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                    reserved = true
                }
            }
        case .upcoming:
            PrimaryButton(title: reminderSet ? "Reminder Saved" : "Remind Me + Reserve Spot", icon: reminderSet ? "bell.badge.fill" : "bell.fill", disabled: reminderSet) {
                EventTracker.track(.REMINDER_REQUESTED)
                EventTracker.track(.OFFER_SCHEDULED)
                withAnimation { reminderSet = true }
                state.showToast("Reminder saved.")
            }
        case .expired:
            PrimaryButton(title: "Offer Expired", disabled: true) {
                EventTracker.track(.OFFER_EXPIRED)
            }
        }
    }

    private func termsCard(offer: Offer) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("TERMS")
                .font(AppFont.body(10, weight: .heavy))
                .tracking(1.5)
                .foregroundStyle(AppColors.textMuted)
            Text(offer.terms)
                .font(AppFont.body(12, weight: .regular))
                .foregroundStyle(AppColors.textMuted)
                .lineSpacing(2)
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Spacing.radius).fill(AppColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: Spacing.radius).stroke(AppColors.border, lineWidth: 1))
    }

    private var groupPackCard: some View {
        GroupPackCard()
    }
}

private struct GroupPackCard: View {
    @Environment(AppState.self) private var state
    @State private var hasTrackedView = false
    @State private var pulse = false

    var body: some View {
        let pack = state.groupPack
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "person.3.fill").foregroundStyle(AppColors.neonBlue)
                    Text("GROUP PACK")
                        .font(AppFont.body(10, weight: .heavy))
                        .tracking(1.5)
                        .foregroundStyle(AppColors.neonBlue)
                }
                Spacer()
                CountdownBadge(minutesLeft: pack.countdownMinutes)
            }

            Text(pack.title)
                .font(AppFont.display(20, weight: .heavy))
                .foregroundStyle(AppColors.textWhite)

            Text(pack.description)
                .font(AppFont.body(13, weight: .regular))
                .foregroundStyle(AppColors.textMuted)

            HStack(spacing: 10) {
                priceCol(label: "Pack price", value: "$\(Int(pack.packPrice))", color: AppColors.textWhite)
                priceCol(label: "Value", value: "$\(Int(pack.packValue))", color: AppColors.textMuted)
                priceCol(label: "You save", value: "$\(Int(pack.savings))", color: AppColors.neonGreen)
            }

            GroupPackProgress(current: pack.currentPeople, required: pack.requiredPeople)

            if pack.status == .unlocked {
                VStack(spacing: 10) {
                    Text("Pack Unlocked")
                        .font(AppFont.display(18, weight: .heavy))
                        .foregroundStyle(AppColors.neonGreen)
                        .scaleEffect(pulse ? 1.06 : 1)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                                pulse = true
                            }
                        }
                    QRPinBlock(pin: state.offer.pin, seed: pack.id)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
            } else {
                HStack(spacing: 10) {
                    PrimaryButton(title: "Join Pack", icon: "plus.circle.fill") {
                        state.joinGroupPack()
                        EventTracker.track(.GROUP_PACK_JOINED)
                        if state.groupPack.status == .unlocked {
                            EventTracker.track(.GROUP_PACK_UNLOCKED)
                        }
                    }
                    SecondaryButton(title: "Share", icon: "square.and.arrow.up") {
                        UIPasteboard.general.string = pack.shareMessage
                        EventTracker.track(.GROUP_PACK_SHARED)
                        state.showToast("Pack link copied.")
                    }
                }
            }

            Text("Pickup window: \(pack.pickupWindow)")
                .font(AppFont.body(11, weight: .medium))
                .foregroundStyle(AppColors.textHint)
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Spacing.radius).fill(AppColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: Spacing.radius).stroke(AppColors.neonBlue.opacity(0.3), lineWidth: 1))
        .onAppear {
            if !hasTrackedView {
                hasTrackedView = true
                EventTracker.track(.GROUP_PACK_VIEWED)
            }
        }
    }

    private func priceCol(label: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(value)
                .font(AppFont.display(16, weight: .heavy))
                .foregroundStyle(color)
            Text(label)
                .font(AppFont.body(10, weight: .medium))
                .foregroundStyle(AppColors.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(RoundedRectangle(cornerRadius: 10).fill(AppColors.bgDeep))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.border, lineWidth: 1))
    }
}
