import Foundation

// OfferRepository
// Returns offers + the current top match for a user.
// Mock mode delegates to BehaviorEngine + MockOffers.
//
// TODO Production (Supabase):
// - fetchTopMatch(userId): call edge function `match_top_offer(userId)`
//   that runs the Behavioral Demand Router server-side using the
//   user's behavior profile + live merchant offers.
// - fetchPeekOffers(userId, excluding:): call `peek_offers(userId)`.
// - fetchOffer(id:): single-row query on `offers` table.
// - reserveOffer(userId, offerId): RPC that decrements spotsLeft
//   atomically and creates an `intents` row (status: reserved).

struct OfferRepository {
    func fetchAll() -> [ConsumerOffer] {
        switch ConsumerDataService.mode {
        case .mock:
            return MockOffers.all
        case .remote:
            // TODO Production: SELECT * FROM offers WHERE active = true.
            return MockOffers.all
        }
    }

    func fetchTopMatch(userId: String, behavior: UserBehavior, exclude: Set<String> = []) -> ConsumerOffer? {
        switch ConsumerDataService.mode {
        case .mock:
            return BehaviorEngine.getTopMatchWithDemoGuard(behavior: behavior, exclude: exclude)
        case .remote:
            // TODO Production: await supabase.rpc("match_top_offer", ["user_id": userId]).
            return BehaviorEngine.getTopMatchWithDemoGuard(behavior: behavior, exclude: exclude)
        }
    }

    func fetchPeekOffers(userId: String, topMatch: ConsumerOffer?, exclude: Set<String> = []) -> [ConsumerOffer] {
        switch ConsumerDataService.mode {
        case .mock:
            return BehaviorEngine.getPeekOffers(topMatch: topMatch, exclude: exclude)
        case .remote:
            // TODO Production: await supabase.rpc("peek_offers", ["user_id": userId]).
            return BehaviorEngine.getPeekOffers(topMatch: topMatch, exclude: exclude)
        }
    }

    func fetchOffer(id: String) -> ConsumerOffer? {
        MockOffers.all.first { $0.id == id }
        // TODO Production: SELECT * FROM offers WHERE id = $1.
    }

    // Reserves a spot when the user taps Claim.
    // TODO Production: RPC `reserve_offer(user_id, offer_id)` that
    // atomically decrements spotsLeft and inserts an intent row.
    func reserveOffer(userId: String, offerId: String) {
        print("[WIN DATA] reserveOffer user=\(userId) offer=\(offerId) mode=\(ConsumerDataService.mode)")
    }
}
