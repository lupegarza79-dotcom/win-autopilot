import Foundation

enum SignalTracker {
    static func recordPass(offerId: String, category: ConsumerCategory, behavior: inout UserBehavior) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let signal = PassSignal(
            offerId: offerId,
            category: category,
            hour: Calendar.current.component(.hour, from: now),
            dayOfWeek: formatter.string(from: now),
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
        print("[WIN SIGNAL] pass offer=\(offerId) category=\(category.rawValue)")
    }

    static func recordClaim(offerId: String, category: ConsumerCategory) {
        print("[WIN SIGNAL] claim offer=\(offerId) category=\(category.rawValue)")
    }

    static func recordRemind(offerId: String, category: ConsumerCategory) {
        print("[WIN SIGNAL] remind offer=\(offerId) category=\(category.rawValue)")
    }
}
