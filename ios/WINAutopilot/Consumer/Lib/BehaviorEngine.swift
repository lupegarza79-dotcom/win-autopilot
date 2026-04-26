import Foundation

// TODO Phase 2 — Ghost Merchant:
// Merchant only inputs:
// - empty seats
// - inventory to move
// - pickup window
// - max redemptions
// - margin guard
//
// WIN decides:
// - which users to notify
// - when to notify
// - what offer format to use
// - how many spots to release
// - when to stop the campaign
//
// Do not build this UI now.
//
// TODO Production: replace demo radar reset with real merchant offer stream / notification engine.

enum BehaviorEngine {
    static func effectiveScore(for offer: ConsumerOffer, behavior: UserBehavior) -> Int {
        var score = offer.matchScore
        let now = Date()
        let hour = Calendar.current.component(.hour, from: now)

        if behavior.topCategories.contains(offer.category) { score += 5 }

        switch offer.category {
        case .tacos, .pizza:
            if (11...14).contains(hour) { score += 5 }
        case .coffee:
            if (7...10).contains(hour) { score += 4 }
        case .gas:
            if (16...19).contains(hour) { score += 4 }
        default:
            break
        }

        let distMiles = Double(offer.distance.replacingOccurrences(of: " mi", with: "")) ?? 99
        if distMiles < 0.8 { score += 3 }

        if offer.countdownMinutes <= 90 { score += 3 }
        if offer.countdownMinutes > 180 { score -= 5 }

        if offer.spotsLeft > 0 && offer.spotsLeft <= 20 { score += 2 }

        let suppressed = behavior.suppressedCategories.contains { s in
            s.category == offer.category && s.until > now
        }
        if suppressed { score -= 20 }

        let recentPass = behavior.passSignals.contains { $0.offerId == offer.id }
        if recentPass { score -= 10 }

        print("[WIN BRAIN] \(offer.businessName) base=\(offer.matchScore) effective=\(score)")
        return score
    }

    static func getTopMatch(behavior: UserBehavior, exclude: Set<String> = []) -> ConsumerOffer? {
        let scored: [(ConsumerOffer, Int)] = MockOffers.all
            .filter { !exclude.contains($0.id) }
            .map { ($0, effectiveScore(for: $0, behavior: behavior)) }
            .filter { $0.1 >= 80 }
            .sorted { $0.1 > $1.1 }

        if let top = scored.first {
            print("[WIN BRAIN] selected \(top.0.businessName)")
            return top.0
        }
        print("[WIN BRAIN] radar state — no effective score above 80")
        return nil
    }

    static func getPeekOffers(topMatch: ConsumerOffer?, exclude: Set<String> = []) -> [ConsumerOffer] {
        MockOffers.all
            .filter { $0.id != topMatch?.id && !exclude.contains($0.id) && $0.matchScore >= 60 }
            .prefix(3)
            .map { $0 }
    }

    static func getContextLine() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        if (7...10).contains(hour) {
            return "Morning pattern matched. Coffee deal found."
        }
        if (11...14).contains(hour) {
            return "Lunch time in McAllen. Your top match is ready."
        }
        if (15...16).contains(hour) {
            return "Nearby reward matched your habits."
        }
        if (17...19).contains(hour) {
            return "Evening deal matched your alerts."
        }
        return "Best deal near you right now."
    }

    static func getTopAlertLabel(alerts: [ConsumerAlert]) -> String {
        guard let first = alerts.first(where: { $0.active }) else {
            return "Watching for your next best deal near McAllen..."
        }
        return "Watching for \(first.label.lowercased()) \(first.condition.lowercased()) near McAllen..."
    }

    static var totalOfferCount: Int { MockOffers.all.count }
}
