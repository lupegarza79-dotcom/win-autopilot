import SwiftUI
import Observation

@Observable
final class AppState {
    var business: Business = MockData.business
    var offer: Offer = MockData.offer
    var upcomingOffer: Offer = MockData.upcomingOffer
    var stats: CampaignStats = MockData.stats
    var groupPack: GroupPack = MockData.groupPack
    var hasLaunchedOffer: Bool = false

    var toast: ToastMessage? = nil

    func showToast(_ message: String) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            toast = ToastMessage(text: message)
        }
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(2500))
            withAnimation(.easeOut(duration: 0.25)) {
                toast = nil
            }
        }
    }

    func applyGenerated(_ p: (title: String, type: RewardType, description: String, whyAIPicked: String, maxRedemptions: Int, countdownMinutes: Int, salesMin: Int, salesMax: Int, terms: String, whatsapp: String)) {
        offer.title = p.title
        offer.type = p.type
        offer.description = p.description
        offer.whyAIPicked = p.whyAIPicked
        offer.maxRedemptions = p.maxRedemptions
        offer.spotsLeft = p.maxRedemptions
        offer.countdownMinutes = p.countdownMinutes
        offer.estimatedSalesMin = p.salesMin
        offer.estimatedSalesMax = p.salesMax
        offer.terms = p.terms
        offer.whatsappMessage = p.whatsapp
    }

    func reserveSpot() {
        if offer.spotsLeft > 0 {
            offer.spotsLeft -= 1
        }
        stats.going += 1
    }

    func redeem(ticket: Double?) {
        stats.redeemed += 1
        let amount = ticket ?? stats.averageTicket
        stats.estimatedSales += amount
        stats.winFee = stats.estimatedSales * 0.10
    }

    func joinGroupPack() {
        if groupPack.status == .open && groupPack.currentPeople < groupPack.requiredPeople {
            groupPack.currentPeople += 1
            if groupPack.currentPeople >= groupPack.requiredPeople {
                groupPack.status = .unlocked
            }
        }
    }
}

struct ToastMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
}
