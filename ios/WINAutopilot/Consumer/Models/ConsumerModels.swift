import Foundation

nonisolated enum ConsumerReaction: String, Sendable {
    case claim
    case pass
    case remind
}

nonisolated enum ConsumerCategory: String, Sendable, CaseIterable {
    case tacos, coffee, gas, haircut, pizza, carwash

    var emoji: String {
        switch self {
        case .tacos: return "🌮"
        case .coffee: return "☕"
        case .gas: return "⛽"
        case .haircut: return "✂️"
        case .pizza: return "🍕"
        case .carwash: return "🚿"
        }
    }

    var symbolName: String {
        switch self {
        case .tacos: return "fork.knife"
        case .coffee: return "cup.and.saucer.fill"
        case .gas: return "fuelpump.fill"
        case .haircut: return "scissors"
        case .pizza: return "fork.knife.circle.fill"
        case .carwash: return "car.fill"
        }
    }
}

nonisolated struct ConsumerOffer: Identifiable, Sendable, Equatable {
    let id: String
    let category: ConsumerCategory
    let businessName: String
    let dealText: String
    let shortDeal: String
    let distance: String
    let walkTime: String
    var spotsLeft: Int
    let spotsTotal: Int
    let countdownMinutes: Int
    let pin: String
    let matchScore: Int
    let matchReason: String
    let gradientStart: String
    let gradientEnd: String
    let imageUrl: String
}

nonisolated struct PassSignal: Sendable {
    let offerId: String
    let category: ConsumerCategory
    let hour: Int
    let dayOfWeek: String
    let reaction: ConsumerReaction
    let timestamp: Date
}

nonisolated struct SuppressedCategory: Sendable {
    let category: ConsumerCategory
    let until: Date
}

struct UserBehavior {
    var passSignals: [PassSignal] = []
    var suppressedCategories: [SuppressedCategory] = []
    var peakHours: [String] = ["12pm", "1pm", "6pm"]
    var topCategories: [ConsumerCategory] = [.tacos, .coffee, .gas]
    var claimedCount: Int = 14
    var totalSaved: Int = 68
}

nonisolated struct ConsumerAlert: Identifiable, Sendable {
    let id: String
    let category: ConsumerCategory
    let emoji: String
    let label: String
    let condition: String
    let timeWindow: String
    var active: Bool
}
