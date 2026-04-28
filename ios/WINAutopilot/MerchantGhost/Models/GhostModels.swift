import Foundation

nonisolated enum MerchantCategory: String, CaseIterable, Identifiable, Codable, Sendable {
    case restaurant = "Restaurant / Tacos"
    case coffee = "Coffee Shop"
    case carwash = "Car Wash"
    case barber = "Barber / Salon"
    case pizza = "Pizza"
    case other = "Other"

    var id: String { rawValue }
}

nonisolated enum InventoryType: String, CaseIterable, Identifiable, Codable, Sendable {
    case bestSeller = "best_seller"
    case highMargin = "high_margin"
    case toMove = "to_move"
    case reward = "reward"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .bestSeller: return "Best Seller"
        case .highMargin: return "High Margin"
        case .toMove: return "To Move"
        case .reward: return "Reward"
        }
    }

    var hint: String {
        switch self {
        case .bestSeller: return "Drives traffic"
        case .highMargin: return "Protects margin"
        case .toMove: return "Move inventory"
        case .reward: return "Free add-on"
        }
    }
}

nonisolated enum WeekDay: String, CaseIterable, Identifiable, Codable, Sendable {
    case mon = "Mon", tue = "Tue", wed = "Wed", thu = "Thu", fri = "Fri", sat = "Sat", sun = "Sun"
    var id: String { rawValue }
}

nonisolated enum GhostOfferKind: String, Codable, Sendable {
    case traffic = "Traffic"
    case marginSafe = "Margin-Safe"
    case groupPack = "Group Pack"
}

nonisolated enum GhostOfferStatus: String, Codable, Sendable {
    case draft, active, paused, expired
}

nonisolated struct Merchant: Identifiable, Codable, Sendable {
    var id: UUID = UUID()
    var name: String = ""
    var category: MerchantCategory = .restaurant
    var address: String = ""
    var hours: String = ""
    var whatsapp: String = ""
    var logoUrl: String = ""
    var createdAt: Date = Date()
}

nonisolated struct MerchantInventoryItem: Identifiable, Codable, Sendable, Hashable {
    var id: UUID = UUID()
    var productName: String
    var type: InventoryType
    var unitCost: Double? = nil
    var active: Bool = true
}

nonisolated struct SlowHour: Identifiable, Codable, Sendable, Hashable {
    var id: UUID = UUID()
    var day: WeekDay
    var startHour: Int
    var endHour: Int
    var discountAllowed: Bool = true

    var label: String {
        "\(day.rawValue) \(formatHour(startHour)) – \(formatHour(endHour))"
    }

    private func formatHour(_ h: Int) -> String {
        let hour12 = ((h + 11) % 12) + 1
        let suffix = h < 12 ? "AM" : "PM"
        return "\(hour12):00 \(suffix)"
    }
}

nonisolated struct MarginGuard: Codable, Sendable {
    var maxDiscountPct: Int = 25
    var maxRedemptions: Int = 25
    var minPurchase: Double = 0
    var pickupOnly: Bool = false
    var active: Bool = true
}

nonisolated struct GhostOffer: Identifiable, Codable, Sendable {
    var id: UUID = UUID()
    var merchantId: UUID
    var kind: GhostOfferKind
    var title: String
    var description: String
    var reason: String
    var imageUrl: String = ""
    var discountPct: Int
    var cap: Int
    var pickupOnly: Bool
    var expiresInMinutes: Int
    var estimatedSalesMin: Int
    var estimatedSalesMax: Int
    var status: GhostOfferStatus = .draft
    var createdByAI: Bool = true
    var createdAt: Date = Date()
}
