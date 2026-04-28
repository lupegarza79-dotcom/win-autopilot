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
// TODO Production: replace demo threshold guard with real merchant offer stream,
// push notifications, and live offer creation.

enum BehaviorEngine {
    private static func recentlyPassed(_ offerId: String, behavior: UserBehavior) -> Bool {
        behavior.passSignals.contains { $0.offerId == offerId }
    }

    private static func isSuppressed(_ category: ConsumerCategory, behavior: UserBehavior, now: Date) -> Bool {
        behavior.suppressedCategories.contains { s in
            s.category == category && s.until > now
        }
    }

    private static func isAlertMatch(_ offer: ConsumerOffer) -> Bool {
        MockUser.alerts.contains { $0.active && $0.category == offer.category }
    }

    static func effectiveScore(for offer: ConsumerOffer, behavior: UserBehavior) -> Int {
        var score = offer.matchScore
        let now = Date()
        let hour = Calendar.current.component(.hour, from: now)
        let isLunch = (11...14).contains(hour)
        let isMorning = (7...10).contains(hour)
        let isEvening = (16...19).contains(hour)

        // BONUSES — Predictive Intelligence
        if isLunch && offer.category == .tacos { score += 12 }
        if isMorning && offer.category == .coffee { score += 10 }
        if behavior.topCategories.contains(offer.category) { score += 8 }
        if isLunch && offer.category == .pizza { score += 6 }
        if isEvening && offer.category == .gas { score += 4 }

        let distMiles = Double(offer.distance.replacingOccurrences(of: " mi", with: "")) ?? 99
        if distMiles < 0.6 { score += 5 }

        if isAlertMatch(offer) { score += 15 }

        if offer.countdownMinutes <= 90 { score += 3 }
        if offer.spotsLeft > 0 && offer.spotsLeft <= 20 { score += 2 }

        if behavior.trustScore >= 90 {
            score += 5
        } else if behavior.trustScore >= 80 {
            score += 3
        }

        if behavior.noShowCount >= 3 {
            score -= 8
        }

        print("[WIN BRAIN] trustScore=\(behavior.trustScore) noShows=\(behavior.noShowCount)")

        // PENALTIES — Anti-Fatigue
        if recentlyPassed(offer.id, behavior: behavior) { score -= 40 }

        if isSuppressed(offer.category, behavior: behavior, now: now) { score -= 60 }

        if offer.countdownMinutes > 180 { score -= 5 }

        print("[WIN BRAIN] evaluating \(offer.businessName) base=\(offer.matchScore) effective=\(score)")
        return score
    }

    static func getTopMatch(behavior: UserBehavior, exclude: Set<String> = [], minimumScore: Int = 80) -> ConsumerOffer? {
        let scored: [(ConsumerOffer, Int)] = MockOffers.all
            .filter { !exclude.contains($0.id) }
            .map { ($0, effectiveScore(for: $0, behavior: behavior)) }
            .filter { $0.1 >= minimumScore }
            .sorted { $0.1 > $1.1 }

        if let top = scored.first {
            print("[WIN BRAIN] selected \(top.0.businessName)")
            return top.0
        }
        print("[WIN BRAIN] radar state — no effective score above \(minimumScore)")
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
        return "Nearby reward matched your habits."
    }

    static func getTopAlertLabel(alerts: [ConsumerAlert]) -> String {
        guard let first = alerts.first(where: { $0.active }) else {
            return "Watching for your next best deal near McAllen..."
        }
        return "Watching for \(first.label.lowercased()) \(first.condition.lowercased()) near McAllen..."
    }

    static var totalOfferCount: Int { MockOffers.all.count }
}
