import SwiftUI
import UIKit

struct MatchScreen: View {
    @State private var behavior = MockUser.behavior
    @State private var dismissedIds: Set<String> = []
    @State private var isFlipped = false
    @State private var dragOffset: CGSize = .zero
    @State private var showAlerts = false
    @State private var toastMessage: String?
    @State private var toastWorkItem: DispatchWorkItem?
    @State private var forcedOfferId: String?

    private var topMatch: ConsumerOffer? {
        if let forcedId = forcedOfferId,
           !dismissedIds.contains(forcedId),
           let offer = MockOffers.all.first(where: { $0.id == forcedId }) {
            return offer
        }
        return BehaviorEngine.getTopMatchWithDemoGuard(behavior: behavior, exclude: dismissedIds)
    }

    private var peekOffers: [ConsumerOffer] {
        BehaviorEngine.getPeekOffers(topMatch: topMatch, exclude: dismissedIds)
    }

    private var contextLine: String {
        topMatch == nil ? "WIN is watching your alerts." : BehaviorEngine.getContextLine()
    }

    var body: some View {
        ZStack {
            ConsumerColors.bgWarm.ignoresSafeArea()

            VStack(spacing: 14) {
                headerRow

                AIContextLine(text: contextLine, isScanning: topMatch == nil)
                    .padding(.horizontal, 16)

                ZStack {
                    if let offer = topMatch {
                        DealCard(offer: offer, isFlipped: $isFlipped, dragOffset: dragOffset)
                            .id(offer.id)
                            .padding(.horizontal, 16)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if !isFlipped {
                                            dragOffset = value.translation
                                        }
                                    }
                                    .onEnded { value in
                                        guard !isFlipped else { return }
                                        if value.translation.width > 110 {
                                            handleClaim(offer)
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                                dragOffset = .zero
                                            }
                                        } else if value.translation.width < -110 {
                                            withAnimation(.easeIn(duration: 0.2)) {
                                                dragOffset = CGSize(width: -600, height: value.translation.height)
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                handlePass(offer)
                                                dragOffset = .zero
                                            }
                                        } else {
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                                dragOffset = .zero
                                            }
                                        }
                                    }
                            )
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.92).combined(with: .opacity),
                                removal: .opacity
                            ))
                    } else {
                        RadarState(
                            topAlertLabel: BehaviorEngine.getTopAlertLabel(alerts: MockUser.alerts),
                            onShowBestMatch: { restoreBestMatch() }
                        )
                        .transition(.opacity)
                    }
                }
                .frame(maxHeight: UIScreen.main.bounds.height * 0.52)
                .animation(.spring(response: 0.5, dampingFraction: 0.85), value: topMatch?.id)
                .onChange(of: topMatch?.id) { _, newId in
                    if newId == nil {
                        // TODO Production: replace demo reset with real merchant offer stream / notification engine.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                                dismissedIds.removeAll()
                                behavior.suppressedCategories.removeAll()
                                forcedOfferId = nil
                                isFlipped = false
                            }
                            showToast("New deals just matched near you.")
                        }
                    }
                }

                if let offer = topMatch {
                    ReactionBar(
                        onPass: { handlePass(offer) },
                        onClaim: { handleClaim(offer) },
                        onRemind: { handleRemind(offer) },
                        disabled: isFlipped
                    )
                    .padding(.bottom, 4)
                }

                if !peekOffers.isEmpty {
                    PeekCards(offers: peekOffers, onSelect: { selectPeek($0) })
                        .padding(.horizontal, 16)
                        .frame(minHeight: 110)
                        .padding(.bottom, 12)
                } else {
                    Spacer(minLength: 0)
                }
            }
            .padding(.top, 4)

            if let msg = toastMessage {
                VStack {
                    Spacer()
                    ConsumerToast(message: msg)
                        .padding(.bottom, 100)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .allowsHitTesting(false)
            }
        }
        .sheet(isPresented: $showAlerts) {
            AlertsScreen(alerts: MockUser.alerts)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    private var headerRow: some View {
        HStack {
            HStack(spacing: 6) {
                Circle()
                    .fill(ConsumerColors.green)
                    .frame(width: 8, height: 8)
                Text("WIN")
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundStyle(ConsumerColors.textDark)
            }
            Spacer()
            Button {
                showAlerts = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 11, weight: .bold))
                    Text("My Alerts")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundStyle(ConsumerColors.textDark)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Capsule().fill(ConsumerColors.bgCard))
                .overlay(Capsule().strokeBorder(ConsumerColors.borderLight, lineWidth: 1))
            }
            .buttonStyle(PressScaleStyle())
        }
        .padding(.horizontal, 20)
    }

    private func handleClaim(_ offer: ConsumerOffer) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        SignalTracker.recordClaim(
            offerId: offer.id,
            category: offer.category,
            businessName: offer.businessName,
            distance: offer.distance,
            countdownMinutes: offer.countdownMinutes,
            matchScore: offer.matchScore
        )
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isFlipped = true
        }
        showToast("Spot reserved.")
    }

    private func handlePass(_ offer: ConsumerOffer) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        SignalTracker.recordPass(offerId: offer.id, category: offer.category, behavior: &behavior)
        dismissedIds.insert(offer.id)
        if forcedOfferId == offer.id { forcedOfferId = nil }
        isFlipped = false
    }

    private func handleRemind(_ offer: ConsumerOffer) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        SignalTracker.recordRemind(offerId: offer.id, category: offer.category)
        showToast("Remind me later. Got it.")
    }

    private func selectPeek(_ offer: ConsumerOffer) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        SignalTracker.recordPeekSelected(offerId: offer.id, category: offer.category)
        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            dismissedIds.remove(offer.id)
            forcedOfferId = offer.id
            isFlipped = false
            dragOffset = .zero
        }
        showToast("Match selected.")
    }

    private func restoreBestMatch() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            dismissedIds.removeAll()
            behavior.suppressedCategories.removeAll()
            forcedOfferId = nil
            isFlipped = false
        }
        showToast("Best match restored.")
    }

    private func showToast(_ message: String) {
        toastWorkItem?.cancel()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            toastMessage = message
        }
        let work = DispatchWorkItem {
            withAnimation(.easeIn(duration: 0.3)) {
                toastMessage = nil
            }
        }
        toastWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: work)
    }
}
