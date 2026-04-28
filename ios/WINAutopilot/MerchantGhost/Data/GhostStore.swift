import SwiftUI

// TODO Production: Replace mock persistence with Supabase repositories.
// Suggested tables:
//   merchants(id, name, category, address, hours_json, whatsapp, logo_url, created_at)
//   merchant_inventory(id, merchant_id, product_name, type, unit_cost, active)
//   slow_hours(id, merchant_id, day_of_week, hour_start, hour_end, discount_allowed)
//   margin_guard(id, merchant_id, max_discount_pct, max_redemptions, min_purchase, pickup_only, active)
//   offers(id, merchant_id, title, description, image_url, discount_pct, cap, claimed_count,
//          redeemed_count, expires_at, status, created_by)

@Observable
final class GhostStore {
    var merchant: Merchant = Merchant()
    var inventory: [MerchantInventoryItem] = []
    var slowHours: [SlowHour] = []
    var marginGuard: MarginGuard = MarginGuard()
    var offers: [GhostOffer] = []
    var generatedDrafts: [GhostOffer] = []
    var sentOfferIds: Set<UUID> = []

    func quickAddSuggestions(for category: MerchantCategory) -> [(String, InventoryType)] {
        switch category {
        case .restaurant:
            return [
                ("Taco Combo", .bestSeller),
                ("Large Drink", .highMargin),
                ("Quesadilla", .bestSeller),
                ("Chips & Salsa", .reward),
                ("Dessert", .toMove)
            ]
        case .coffee:
            return [
                ("Latte", .bestSeller),
                ("Iced Coffee", .bestSeller),
                ("Pastry", .highMargin),
                ("Free Add-On", .reward),
                ("Breakfast Combo", .toMove)
            ]
        case .carwash:
            return [
                ("Basic Wash", .bestSeller),
                ("Express Wash", .bestSeller),
                ("Interior Add-On", .highMargin),
                ("Wax Upgrade", .toMove)
            ]
        case .barber:
            return [
                ("Classic Cut", .bestSeller),
                ("Beard Trim", .highMargin),
                ("Hot Towel Add-On", .reward),
                ("Color Touch-Up", .toMove)
            ]
        case .pizza:
            return [
                ("Large Pizza", .bestSeller),
                ("Garlic Knots", .highMargin),
                ("Soda 2L", .reward),
                ("Calzone", .toMove)
            ]
        case .other:
            return [
                ("Top Item", .bestSeller),
                ("High Margin Add-On", .highMargin),
                ("Slow-Moving Item", .toMove),
                ("Free Reward", .reward)
            ]
        }
    }

    // MARK: - Repository surface (mock now, Supabase later)

    func saveMerchant() {
        // TODO Supabase: upsert merchant row.
        print("[GHOST] saveMerchant", merchant.name, merchant.category.rawValue)
    }

    func addInventoryItem(_ item: MerchantInventoryItem) {
        inventory.append(item)
        // TODO Supabase: insert merchant_inventory row.
        print("[GHOST] addInventoryItem", item.productName, item.type.rawValue)
    }

    func removeInventoryItem(_ id: UUID) {
        inventory.removeAll { $0.id == id }
        // TODO Supabase: delete merchant_inventory row.
    }

    func addSlowHour(_ hour: SlowHour) {
        slowHours.append(hour)
        // TODO Supabase: insert slow_hours row.
        print("[GHOST] addSlowHour", hour.label)
    }

    func removeSlowHour(_ id: UUID) {
        slowHours.removeAll { $0.id == id }
    }

    func saveMarginGuard() {
        // TODO Supabase: upsert margin_guard row.
        print("[GHOST] saveMarginGuard pct=\(marginGuard.maxDiscountPct) cap=\(marginGuard.maxRedemptions)")
    }

    func generateDrafts() {
        generatedDrafts = GhostEngine.generateMerchantOffers(
            merchant: merchant,
            inventory: inventory,
            slowHours: slowHours,
            marginGuard: marginGuard
        )
        print("[GHOST] generated \(generatedDrafts.count) AI drafts")
    }

    func sendToConsumerMatchmaker(_ offer: GhostOffer) {
        var stamped = offer
        stamped.status = .active
        offers.append(stamped)
        sentOfferIds.insert(offer.id)
        // TODO Supabase: insert offers row + emit event for Consumer matchmaker stream.
        print("[GHOST] sendToConsumerMatchmaker \(offer.title)")
    }
}
