import Foundation

nonisolated enum OfferStatus: String, Codable, Sendable {
    case now, upcoming, expired
}

nonisolated enum GroupPackStatus: String, Codable, Sendable {
    case open, unlocked, expired
}

nonisolated enum RewardType: String, Codable, Sendable, CaseIterable, Identifiable {
    case percent_off, dollar_off, free_add_on, group_pack
    var id: String { rawValue }
    var label: String {
        switch self {
        case .percent_off: return "% OFF"
        case .dollar_off: return "$ OFF"
        case .free_add_on: return "FREE"
        case .group_pack: return "GROUP"
        }
    }
}

nonisolated struct Business: Codable, Sendable {
    var name: String
    var category: String
    var address: String
    var phone: String
    var whatsapp: String
    var averageTicket: Double
    var slowHours: String
    var bestItems: [String]
    var highMarginItems: [String]
    var maxRedemptions: Int
}

nonisolated struct Offer: Identifiable, Codable, Sendable {
    var id: String
    var type: RewardType
    var title: String
    var description: String
    var whyAIPicked: String
    var timeWindow: String
    var countdownMinutes: Int
    var maxRedemptions: Int
    var spotsLeft: Int
    var estimatedSalesMin: Int
    var estimatedSalesMax: Int
    var terms: String
    var whatsappMessage: String
    var publicLink: String
    var pin: String
    var status: OfferStatus
    var startsAt: String
    var endsAt: String
    var distance: String
    var proximityLabel: String
}

nonisolated struct CampaignStats: Codable, Sendable {
    var views: Int
    var shares: Int
    var going: Int
    var redeemed: Int
    var noShows: Int
    var estimatedSales: Double
    var averageTicket: Double
    var winFee: Double
}

nonisolated struct GroupPack: Identifiable, Codable, Sendable {
    var id: String
    var packType: String
    var title: String
    var description: String
    var requiredPeople: Int
    var currentPeople: Int
    var pickupWindow: String
    var packPrice: Double
    var packValue: Double
    var savings: Double
    var shareMessage: String
    var status: GroupPackStatus
    var countdownMinutes: Int
}

nonisolated enum EventName: String, Sendable {
    case BUSINESS_CREATED
    case OFFER_GENERATED
    case OFFER_REGENERATED
    case OFFER_LAUNCHED
    case OFFER_VIEWED
    case OFFER_SHARED
    case INTENT_RESERVED
    case QR_GENERATED
    case PIN_VALIDATED
    case OFFER_REDEEMED
    case OFFER_EXPIRED
    case NO_SHOW
    case AI_RECOMMENDATION_CREATED
    case GROUP_PACK_CREATED
    case GROUP_PACK_VIEWED
    case GROUP_PACK_JOINED
    case GROUP_PACK_SHARED
    case GROUP_PACK_UNLOCKED
    case GROUP_PACK_EXPIRED
    case OFFER_SCHEDULED
    case UPCOMING_OFFER_VIEWED
    case REMINDER_REQUESTED
    case NEARBY_OFFER_VIEWED
}
