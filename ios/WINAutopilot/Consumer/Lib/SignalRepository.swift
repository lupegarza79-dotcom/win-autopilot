import Foundation

// SignalRepository
// Records behavioral signals (pass / claim / remind / peek_select).
// Mock mode delegates to SignalTracker (which prints + mutates local UserBehavior).
//
// TODO Production (Supabase):
// - sendSignal(userId, offerId, reaction, payload): INSERT into `signals` table.
// - Edge function consumes the row to update the user's behavior profile,
//   suppression rules, TrustScore, and category preferences.
// - Batch signals when offline; flush on reconnect.

struct SignalRepository {
    func sendPass(userId: String, offerId: String, category: ConsumerCategory, behavior: inout UserBehavior) {
        SignalTracker.recordPass(offerId: offerId, category: category, behavior: &behavior)
        // TODO Production: await supabase.from("signals").insert([...]).
        print("[WIN DATA] sendSignal user=\(userId) offer=\(offerId) reaction=pass mode=\(ConsumerDataService.mode)")
    }

    func sendClaim(userId: String, offer: ConsumerOffer) {
        SignalTracker.recordClaim(
            offerId: offer.id,
            category: offer.category,
            businessName: offer.businessName,
            distance: offer.distance,
            countdownMinutes: offer.countdownMinutes,
            matchScore: offer.matchScore
        )
        // TODO Production: await supabase.from("signals").insert([...]).
        print("[WIN DATA] sendSignal user=\(userId) offer=\(offer.id) reaction=claim mode=\(ConsumerDataService.mode)")
    }

    func sendRemind(userId: String, offerId: String, category: ConsumerCategory) {
        SignalTracker.recordRemind(offerId: offerId, category: category)
        // TODO Production: await supabase.from("signals").insert([...]).
        print("[WIN DATA] sendSignal user=\(userId) offer=\(offerId) reaction=remind mode=\(ConsumerDataService.mode)")
    }

    func sendPeekSelected(userId: String, offerId: String, category: ConsumerCategory) {
        SignalTracker.recordPeekSelected(offerId: offerId, category: category)
        // TODO Production: await supabase.from("signals").insert([...]).
        print("[WIN DATA] sendSignal user=\(userId) offer=\(offerId) reaction=peek_select mode=\(ConsumerDataService.mode)")
    }
}
