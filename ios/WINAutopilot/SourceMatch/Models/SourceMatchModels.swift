import Foundation
import SwiftUI

enum SourceCategory: String, Codable, CaseIterable {
    case food, coffee, beauty, homeService

    var label: String {
        switch self {
        case .food: return "Food"
        case .coffee: return "Coffee"
        case .beauty: return "Beauty"
        case .homeService: return "Home Service"
        }
    }

    var symbol: String {
        switch self {
        case .food: return "fork.knife"
        case .coffee: return "cup.and.saucer.fill"
        case .beauty: return "scissors"
        case .homeService: return "wrench.and.screwdriver.fill"
        }
    }

    var accent: Color {
        switch self {
        case .food: return Color(red: 0.95, green: 0.45, blue: 0.20)
        case .coffee: return Color(red: 0.62, green: 0.40, blue: 0.20)
        case .beauty: return Color(red: 0.62, green: 0.30, blue: 0.70)
        case .homeService: return Color(red: 0.20, green: 0.55, blue: 0.85)
        }
    }
}

struct TrustCheck: Identifiable, Hashable {
    let id = UUID()
    let label: String
    let passed: Bool
}

struct SourceMatchItem: Identifiable, Hashable {
    let id: String
    let merchantName: String
    let category: SourceCategory
    let headline: String
    let description: String
    let value: String
    let price: String
    let countdown: String
    let matchScore: Int
    let matchReason: String
    let trustScore: Int
    let trustChecks: [TrustCheck]
    let terms: [String]
    let urgency: String
    let preferredTime: String
    let budget: String
    let serviceArea: String
    let autopilotNextStep: String
    let providerNextAction: String
}

enum SourceActivityType: String, Codable {
    case interested, saved, passed
}

enum SourceActivityStatus: String, Codable {
    case saved
    case sourcePreparing
    case sentToProvider
    case providerReviewing
    case confirmed
    case expired
    case passed

    var label: String {
        switch self {
        case .saved: return "Saved"
        case .sourcePreparing: return "SOURCE preparing"
        case .sentToProvider: return "Sent to provider"
        case .providerReviewing: return "Provider reviewing"
        case .confirmed: return "Confirmed"
        case .expired: return "Expired"
        case .passed: return "Passed"
        }
    }

    var color: Color {
        switch self {
        case .saved: return SourceColors.aiBlue
        case .sourcePreparing, .providerReviewing: return SourceColors.urgency
        case .sentToProvider: return SourceColors.aiBlue
        case .confirmed: return SourceColors.success
        case .expired: return SourceColors.danger
        case .passed: return Color.gray
        }
    }
}

struct SourceActivityEvent: Identifiable, Hashable {
    let id: String
    let itemId: String
    var type: SourceActivityType
    var status: SourceActivityStatus
    let createdAt: Date
}

enum SourceColors {
    static let bg = Color(red: 0.04, green: 0.05, blue: 0.08)
    static let bgCard = Color(red: 0.08, green: 0.10, blue: 0.14)
    static let bgElevated = Color(red: 0.12, green: 0.14, blue: 0.18)
    static let border = Color.white.opacity(0.08)
    static let borderMid = Color.white.opacity(0.16)

    static let aiBlue = Color(red: 0.20, green: 0.55, blue: 1.00)
    static let aiBlueSoft = Color(red: 0.20, green: 0.55, blue: 1.00).opacity(0.14)
    static let trustGold = Color(red: 1.00, green: 0.78, blue: 0.20)
    static let trustGoldSoft = Color(red: 1.00, green: 0.78, blue: 0.20).opacity(0.14)
    static let success = Color(red: 0.20, green: 0.85, blue: 0.45)
    static let urgency = Color(red: 1.00, green: 0.55, blue: 0.10)
    static let danger = Color(red: 0.95, green: 0.30, blue: 0.35)

    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.65)
    static let textMuted = Color.white.opacity(0.40)
}
