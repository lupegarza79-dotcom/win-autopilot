import Foundation

// TODO Phase 2 — Ghost Merchant:
// Merchant only inputs:
// - empty seats
// - inventory to move
// - pickup window
// - max redemptions
// - margin guard
// WIN decides:
// - which users to notify
// - when to notify
// - what offer format to use
// - how many spots to release
// - when to stop the campaign
// TODO Future:
// - Auto-ingest menu from Google Business / Instagram / website.
// - Auto-detect slow hours from historical traffic.
// - Auto-suggest inventory-to-move.
// - Merchant only approves campaigns.
// - WIN decides who receives the offer and when.

enum GhostEngine {
    static func generateMerchantOffers(
        merchant: Merchant,
        inventory: [MerchantInventoryItem],
        slowHours: [SlowHour],
        marginGuard: MarginGuard
    ) -> [GhostOffer] {
        let bestSeller = inventory.first { $0.type == .bestSeller && $0.active }
        let highMargin = inventory.first { $0.type == .highMargin && $0.active }
        let toMove = inventory.first { $0.type == .toMove && $0.active } ?? bestSeller
        let reward = inventory.first { $0.type == .reward && $0.active } ?? highMargin

        let cap = max(5, marginGuard.maxRedemptions)
        let maxPct = max(5, min(50, marginGuard.maxDiscountPct))
        let window = primarySlowWindow(slowHours)
        let pickup = marginGuard.pickupOnly

        let avgTicket: Double = 18
        var offers: [GhostOffer] = []

        // 1. Traffic Offer
        let trafficItem = bestSeller?.productName ?? "Combo"
        let trafficPct = min(20, maxPct)
        offers.append(GhostOffer(
            merchantId: merchant.id,
            kind: .traffic,
            title: "\(trafficPct)% OFF \(trafficItem)",
            description: "Designed to fill \(window). \(pickup ? "Pickup only. " : "")Cap of \(cap) redemptions to protect margin.",
            reason: "Best for filling \(window). Uses your top-seller \(trafficItem) to pull traffic fast.",
            discountPct: trafficPct,
            cap: cap,
            pickupOnly: pickup,
            expiresInMinutes: 90,
            estimatedSalesMin: Int(avgTicket * 8),
            estimatedSalesMax: Int(avgTicket * 18)
        ))

        // 2. Margin-Safe Offer
        let rewardItem = reward?.productName ?? "Add-On"
        let baseItem = bestSeller?.productName ?? "Order"
        offers.append(GhostOffer(
            merchantId: merchant.id,
            kind: .marginSafe,
            title: "FREE \(rewardItem) with \(baseItem)",
            description: "Protects price while increasing perceived value during \(window).\(pickup ? " Pickup only." : "")",
            reason: "FREE add-ons protect margin better than % OFF. \(rewardItem) is high-margin so the offer feels valuable without hurting your base ticket.",
            discountPct: 0,
            cap: max(10, cap - 5),
            pickupOnly: pickup,
            expiresInMinutes: 90,
            estimatedSalesMin: Int(avgTicket * 6),
            estimatedSalesMax: Int(avgTicket * 14)
        ))

        // 3. Group Pack
        let packItem = toMove?.productName ?? bestSeller?.productName ?? "Combo"
        offers.append(GhostOffer(
            merchantId: merchant.id,
            kind: .groupPack,
            title: "Pay 3, Get 5 \(packItem)s",
            description: "Group Pack to move inventory and trigger sharing during \(window). Pickup window only.",
            reason: "Moves inventory and encourages sharing. Best when you have surplus \(packItem) capacity.",
            discountPct: 40,
            cap: max(5, cap / 2),
            pickupOnly: true,
            expiresInMinutes: 60,
            estimatedSalesMin: Int(avgTicket * 5),
            estimatedSalesMax: Int(avgTicket * 12)
        ))

        return offers
    }

    private static func primarySlowWindow(_ hours: [SlowHour]) -> String {
        guard let first = hours.first else { return "your slow window" }
        return first.label
    }
}
