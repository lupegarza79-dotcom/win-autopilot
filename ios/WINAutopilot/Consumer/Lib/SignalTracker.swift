import Foundation

// TODO Production:
// Outcome signals to capture in addition to reactions:
// - QR redeemed
// - user arrived
// - merchant accepted
// - user returned within 7 days
// - user saved money
// - merchant received incremental sale
// - no-show happened
//
// The moat:
// click is weak
// claim is stronger
// redemption is proof
// repeat redemption is gold

enum SignalTracker {
    static func recordPass(offerId: String, category: ConsumerCategory, behavior: inout UserBehavior) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let hour = Calendar.current.component(.hour, from: now)
        let day = formatter.string(from: now)
        let signal = PassSignal(
            offerId: offerId,
            category: category,
            hour: hour,
            dayOfWeek: day,
            reaction: .pass,
            timestamp: now
        )
        let cutoff = now.addingTimeInterval(-48 * 60 * 60)
        let recentPasses = behavior.passSignals.filter { $0.category == category && $0.timestamp > cutoff }
        if recentPasses.count >= 1 {
            let until = now.addingTimeInterval(48 * 60 * 60)
            behavior.suppressedCategories.removeAll { $0.category == category }
            behavior.suppressedCategories.append(SuppressedCategory(category: category, until: until))
            print("[WIN BRAIN] Suppressing category: \(category.rawValue)")
        }
        behavior.passSignals.append(signal)
        print("[WIN SIGNAL] pass offer=\(offerId) category=\(category.rawValue) hour=\(hour) day=\(day) reaction=pass")
    }

    static func recordClaim(offerId: String, category: ConsumerCategory, businessName: String = "", distance: String = "", countdownMinutes: Int = 0, matchScore: Int = 0) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let hour = Calendar.current.component(.hour, from: now)
        let day = formatter.string(from: now)
        print("[WIN SIGNAL] claim offer=\(offerId) category=\(category.rawValue) business=\(businessName) hour=\(hour) day=\(day) distance=\(distance) countdown=\(countdownMinutes) matchScore=\(matchScore) reaction=claim intent_to_redeem=true")
        // TODO Production: wait for QR/PIN redemption outcome to confirm proof.
    }

    static func recordRemind(offerId: String, category: ConsumerCategory) {
        let now = Date()
        let hour = Calendar.current.component(.hour, from: now)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let day = formatter.string(from: now)
        print("[WIN SIGNAL] remind offer=\(offerId) category=\(category.rawValue) hour=\(hour) day=\(day) reaction=remind timing_preference=true")
    }

    static func recordPeekSelected(offerId: String, category: ConsumerCategory) {
        print("[WIN SIGNAL] peek_selected offer=\(offerId) category=\(category.rawValue) reaction=peek_select curiosity_signal=true")
    }

    // TODO Production:
    // A no-show means the loop broke. Diagnose:
    // - Was countdown too long?
    // - Was distance too far?
    // - Did user forget?
    // - Was the deal not urgent enough?
    // - Did merchant run out?
    // Use this to tune reminders, urgency, distance threshold, and offer strength.
    static func recordNoShow(offer: ConsumerOffer) {
        let now = Date()
        let hour = Calendar.current.component(.hour, from: now)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let day = formatter.string(from: now)
        print("[WIN SIGNAL] NO_SHOW offer=\(offer.id) business=\(offer.businessName) category=\(offer.category.rawValue) hour=\(hour) day=\(day) distance=\(offer.distance) countdown=\(offer.countdownMinutes) matchScore=\(offer.matchScore) reason=claimed_but_not_redeemed")
    }
}
