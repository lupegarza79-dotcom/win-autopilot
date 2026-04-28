import Foundation

enum SignalTracker {
    // TODO Production:
    // User signals:
    // - claim
    // - pass
    // - remind
    // - peek_select
    // - time of day
    // - day of week
    // - distance
    // - price/reward type
    // - countdown remaining
    // - repeat behavior
    // - redemption
    // - no-show
    //
    // Merchant signals:
    // - slow_hours
    // - empty_seats
    // - inventory_to_move
    // - max_redemptions
    // - desired_customer_type
    // - margin_guard
    // - pickup_window
    // - urgency
    //
    // Outcome signals:
    // - QR redeemed
    // - user arrived
    // - merchant accepted
    // - user returned within 7 days
    // - user saved money
    // - merchant received incremental sale
    // - no-show happened
    //
    // This is the moat:
    // click is weak
    // claim is stronger
    // redemption is proof
    // repeat redemption is gold

    static func recordPass(offer: ConsumerOffer, behavior: inout UserBehavior) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let signal = PassSignal(
            offerId: offer.id,
            category: offer.category,
            hour: Calendar.current.component(.hour, from: now),
            dayOfWeek: formatter.string(from: now),
            reaction: .pass,
            timestamp: now
        )
        let cutoff = now.addingTimeInterval(-48 * 60 * 60)
        let recentPasses = behavior.passSignals.filter { $0.category == offer.category && $0.timestamp > cutoff }
        if recentPasses.count >= 1 {
            let until = now.addingTimeInterval(48 * 60 * 60)
            behavior.suppressedCategories.removeAll { $0.category == offer.category }
            behavior.suppressedCategories.append(SuppressedCategory(category: offer.category, until: until))
            print("[WIN BRAIN] Suppressing category: \(offer.category.rawValue)")
        }
        behavior.passSignals.append(signal)
        print("[WIN SIGNAL] PASS offer=\(offer.id) category=\(offer.category.rawValue) hour=\(signal.hour) day=\(signal.dayOfWeek) distance=\(offer.distance) countdown=\(offer.countdownMinutes)m match=\(offer.matchScore) reaction=pass")
    }

    static func recordClaim(offer: ConsumerOffer) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let hour = Calendar.current.component(.hour, from: now)
        let day = formatter.string(from: now)
        print("[WIN SIGNAL] CLAIM offer=\(offer.id) category=\(offer.category.rawValue) business=\(offer.businessName) hour=\(hour) day=\(day) distance=\(offer.distance) countdown=\(offer.countdownMinutes)m match=\(offer.matchScore) reaction=claim intent_to_redeem=true")
        // TODO Production: wait for QR redemption outcome and feed learning loop.
    }

    static func recordRemind(offer: ConsumerOffer) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let hour = Calendar.current.component(.hour, from: now)
        let day = formatter.string(from: now)
        print("[WIN SIGNAL] REMIND offer=\(offer.id) category=\(offer.category.rawValue) hour=\(hour) day=\(day) reaction=remind timing_preference=true")
    }

    static func recordPeekSelected(offer: ConsumerOffer) {
        print("[WIN SIGNAL] PEEK_SELECT offer=\(offer.id) category=\(offer.category.rawValue) reaction=peek_select curiosity_signal=true")
    }

    // TODO Production:
    // A no-show means the loop broke.
    // Diagnose:
    // - Was countdown too long?
    // - Was distance too far?
    // - Did user forget?
    // - Was the deal not urgent enough?
    // - Did merchant run out?
    // Use this to tune reminders, urgency, distance threshold, and offer strength.
    static func recordNoShow(offer: ConsumerOffer) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let hour = Calendar.current.component(.hour, from: now)
        let day = formatter.string(from: now)
        print("[WIN SIGNAL] NO_SHOW offer=\(offer.id) category=\(offer.category.rawValue) business=\(offer.businessName) hour=\(hour) day=\(day) distance=\(offer.distance) countdown=\(offer.countdownMinutes)m match=\(offer.matchScore) reason=claimed_but_not_redeemed")
    }
}
