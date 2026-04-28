import Foundation

// ConsumerDataService
// Single entry point for all data access in WIN Consumer.
// Currently routes everything to local mock repositories.
// When Supabase / backend is wired up, swap `mode = .remote` and
// implement the remote branches inside each repository.
//
// TODO Production:
// - Inject userId from auth/session layer.
// - Replace MockOffers / MockUser sources with Supabase queries.
// - Add caching + offline fallback.

nonisolated enum ConsumerDataMode: Sendable {
    case mock
    case remote
}

enum ConsumerDataService {
    static var mode: ConsumerDataMode = .mock

    static let offers = OfferRepository()
    static let signals = SignalRepository()
    static let redemptions = RedemptionRepository()

    // TODO Production: derive from authenticated session.
    static var currentUserId: String { "demo-user" }
}
