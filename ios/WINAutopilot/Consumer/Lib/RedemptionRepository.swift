import Foundation

// RedemptionRepository
// Tracks the proof side of the loop: redemption + no-show outcomes.
// Mock mode just logs locally. There is no merchant validator UI in WIN Consumer.
//
// TODO Production (Supabase):
// - markRedeemed(userId, offerId, pin): RPC `redeem_offer(user_id, offer_id, pin)`
//   verifies the PIN, marks the intent as redeemed, increments TrustScore,
//   and emits a redemption event for the merchant dashboard.
// - markNoShow(userId, offerId): RPC `mark_no_show(user_id, offer_id)`
//   called when an intent expires without a redemption. Decrements TrustScore.
// - fetchRedemptionHistory(userId): SELECT * FROM redemptions WHERE user_id = $1.

struct RedemptionRepository {
    @discardableResult
    func markRedeemed(userId: String, offerId: String, pin: String) -> Bool {
        guard let offer = MockOffers.all.first(where: { $0.id == offerId }) else { return false }
        let valid = offer.pin == pin
        print("[WIN DATA] markRedeemed user=\(userId) offer=\(offerId) pin=\(pin) valid=\(valid) mode=\(ConsumerDataService.mode)")
        // TODO Production: await supabase.rpc("redeem_offer", [...]).
        return valid
    }

    func markNoShow(userId: String, offerId: String) {
        if let offer = MockOffers.all.first(where: { $0.id == offerId }) {
            SignalTracker.recordNoShow(offer: offer)
        }
        print("[WIN DATA] markNoShow user=\(userId) offer=\(offerId) mode=\(ConsumerDataService.mode)")
        // TODO Production: await supabase.rpc("mark_no_show", [...]).
    }
}
