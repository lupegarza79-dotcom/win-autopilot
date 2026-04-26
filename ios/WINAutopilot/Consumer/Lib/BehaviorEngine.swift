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

enum BehaviorEngine {
    static func getTopMatch(behavior: UserBehavior, exclude: Set<String> = []) -> ConsumerOffer? {
        let now = Date()
        let available = MockOffers.all.filter { offer in
            if exclude.contains(offer.id) { return false }
            let suppressed = behavior.suppressedCategories.contains { s in
                s.category == offer.category && s.until > now
            }
            return !suppressed && offer.matchScore >= 80
        }
        return available.sorted { $0.matchScore > $1.matchScore }.first
    }

    static func getPeekOffers(topMatch: ConsumerOffer?, exclude: Set<String> = []) -> [ConsumerOffer] {
        MockOffers.all
            .filter { $0.id != topMatch?.id && !exclude.contains($0.id) && $0.matchScore >= 60 }
            .prefix(3)
            .map { $0 }
    }

    static func getContextLine() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        if (11...14).contains(hour) {
            return "Lunch time in McAllen. Your top match is ready."
        }
        if (7...10).contains(hour) {
            return "Good morning. A coffee deal matched your habits."
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
}
