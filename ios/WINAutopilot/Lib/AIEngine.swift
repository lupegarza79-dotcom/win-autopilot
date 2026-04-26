import Foundation

enum AIEngine {
    static func generatePromo(business: Business) -> (title: String, type: RewardType, description: String, whyAIPicked: String, maxRedemptions: Int, countdownMinutes: Int, salesMin: Int, salesMax: Int, terms: String, whatsapp: String) {
        let item = business.bestItems.first ?? "Combo"
        return (
            title: "20% OFF \(item)",
            type: .percent_off,
            description: "Designed to bring traffic during your slow window: \(business.slowHours).",
            whyAIPicked: "AI picked this because \(business.slowHours) is your slowest window and \(item) is your most popular item. Limiting redemptions protects your margin.",
            maxRedemptions: business.maxRedemptions,
            countdownMinutes: 90,
            salesMin: Int((business.averageTicket * 8).rounded()),
            salesMax: Int((business.averageTicket * 18).rounded()),
            terms: "Valid today only. One per customer. Cannot be combined with other offers.",
            whatsapp: "🔥 \(business.name) has 20% OFF \(item) today during \(business.slowHours). Limited spots! Tap to reserve yours."
        )
    }

    static func regeneratePromo(business: Business) -> (title: String, type: RewardType, description: String, whyAIPicked: String, maxRedemptions: Int, countdownMinutes: Int, salesMin: Int, salesMax: Int, terms: String, whatsapp: String) {
        let item = business.highMarginItems.first ?? "Add-on"
        return (
            title: "FREE \(item) with any combo",
            type: .free_add_on,
            description: "Add a FREE \(item) during \(business.slowHours) to increase traffic while protecting your base price.",
            whyAIPicked: "FREE add-ons protect margin better than discounts. \(item) is a high-margin item, so the offer feels valuable without hurting your main ticket price.",
            maxRedemptions: 20,
            countdownMinutes: 90,
            salesMin: Int((business.averageTicket * 6).rounded()),
            salesMax: Int((business.averageTicket * 15).rounded()),
            terms: "Valid today only. One per customer. Dine-in or pickup only.",
            whatsapp: "🎁 \(business.name) is giving FREE \(item) with any combo during \(business.slowHours). Limited spots! Tap to claim yours."
        )
    }

    static func generateInsight(stats: CampaignStats) -> String {
        if stats.views > 100 && stats.redeemed < 15 {
            return "Many people saw your offer but fewer came in. Next time try a FREE add-on instead of % OFF — it feels like more value to the customer while protecting your margin."
        }
        if stats.going > 15 && stats.noShows > 8 {
            return "You had strong intent but too many no-shows. Next time add a reminder 30 minutes before the offer expires."
        }
        return "This offer performed well — \(stats.redeemed) redemptions from \(stats.views) views. Run a similar promo tomorrow during the same slow window with fewer spots to create urgency."
    }

    static func rewardTypeExplanation(_ type: RewardType) -> String {
        switch type {
        case .percent_off: return "Use % OFF when you need traffic fast. Best for slow hours."
        case .dollar_off: return "Use $ OFF with a minimum purchase to increase ticket size."
        case .free_add_on: return "Use FREE add-on to protect margin while increasing perceived value."
        case .group_pack: return "Use Group Pack to move inventory and trigger sharing. Example: Pay 3, Get 5."
        }
    }
}
