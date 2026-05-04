import Foundation
import SwiftUI

@Observable
final class SourceMatchStore {
    var items: [SourceMatchItem] = SourceMatchMockData.items
    var activity: [SourceActivityEvent] = []
    var currentIndex: Int = 0

    var currentItem: SourceMatchItem? {
        guard currentIndex < items.count else { return nil }
        return items[currentIndex]
    }

    func advance() {
        currentIndex += 1
    }

    func recordInterested(_ item: SourceMatchItem) -> SourceActivityEvent {
        let event = SourceActivityEvent(
            id: UUID().uuidString,
            itemId: item.id,
            type: .interested,
            status: .sourcePreparing,
            createdAt: Date()
        )
        activity.insert(event, at: 0)
        print("[SOURCE] interested item=\(item.id) merchant=\(item.merchantName) trust=\(item.trustScore)")
        return event
    }

    func recordSaved(_ item: SourceMatchItem) {
        activity.insert(
            SourceActivityEvent(
                id: UUID().uuidString,
                itemId: item.id,
                type: .saved,
                status: .saved,
                createdAt: Date()
            ),
            at: 0
        )
        print("[SOURCE] saved item=\(item.id)")
    }

    func recordPassed(_ item: SourceMatchItem) {
        activity.insert(
            SourceActivityEvent(
                id: UUID().uuidString,
                itemId: item.id,
                type: .passed,
                status: .passed,
                createdAt: Date()
            ),
            at: 0
        )
        print("[SOURCE] passed item=\(item.id)")
    }

    func updateStatus(eventId: String, status: SourceActivityStatus) {
        if let idx = activity.firstIndex(where: { $0.id == eventId }) {
            activity[idx].status = status
            print("[SOURCE] event=\(eventId) status=\(status.rawValue)")
        }
    }

    func item(for event: SourceActivityEvent) -> SourceMatchItem? {
        items.first(where: { $0.id == event.itemId })
    }
}

enum SourceMatchMockData {
    static let items: [SourceMatchItem] = [
        SourceMatchItem(
            id: "src_tacos",
            merchantName: "Don Pepe Tacos",
            category: .food,
            headline: "2x1 Taco Tuesday",
            description: "Two tacos for the price of one — today only.",
            value: "Save up to $12",
            price: "From $8",
            countdown: "18 min left",
            matchScore: 94,
            matchReason: "You're nearby and usually claim lunch deals around this time.",
            trustScore: 96,
            trustChecks: [
                TrustCheck(label: "Verified business", passed: true),
                TrustCheck(label: "Clear terms", passed: true),
                TrustCheck(label: "Price verified", passed: true),
                TrustCheck(label: "No bait-and-switch", passed: true),
                TrustCheck(label: "Proof available", passed: true),
            ],
            terms: [
                "Valid today only.",
                "Pickup only.",
                "Cannot combine with other offers.",
            ],
            urgency: "High — expires today",
            preferredTime: "Today, 12:00 – 2:00 PM",
            budget: "$8 – $12",
            serviceArea: "0.3 mi — McAllen, TX",
            autopilotNextStep: "SOURCE will hold the offer and prepare pickup instructions.",
            providerNextAction: "Merchant has 15 minutes to confirm pickup availability."
        ),
        SourceMatchItem(
            id: "src_coffee",
            merchantName: "Luna Coffee",
            category: .coffee,
            headline: "Free Iced Latte with Any Breakfast Item",
            description: "Bundle a breakfast item and the latte is on the house.",
            value: "$6 value",
            price: "From $7",
            countdown: "42 min left",
            matchScore: 89,
            matchReason: "You often choose coffee offers in the morning and this shop is close.",
            trustScore: 93,
            trustChecks: [
                TrustCheck(label: "Verified business", passed: true),
                TrustCheck(label: "Clear terms", passed: true),
                TrustCheck(label: "Price verified", passed: true),
                TrustCheck(label: "Proof available", passed: true),
            ],
            terms: [
                "Valid until 11 AM.",
                "One per customer.",
                "Pickup only.",
            ],
            urgency: "Medium — morning window",
            preferredTime: "Today before 11:00 AM",
            budget: "$5 – $10",
            serviceArea: "0.6 mi — McAllen, TX",
            autopilotNextStep: "SOURCE will hold the offer and prepare pickup instructions.",
            providerNextAction: "Merchant has 15 minutes to confirm pickup availability."
        ),
        SourceMatchItem(
            id: "src_barber",
            merchantName: "Elite Barber Studio",
            category: .beauty,
            headline: "Next Slot 2:00 PM — $10 OFF",
            description: "An open chair at 2 PM with $10 off any cut.",
            value: "Save $10",
            price: "From $25",
            countdown: "2 slots left",
            matchScore: 91,
            matchReason: "You saved grooming services and this provider has availability today.",
            trustScore: 95,
            trustChecks: [
                TrustCheck(label: "Verified business", passed: true),
                TrustCheck(label: "Clear terms", passed: true),
                TrustCheck(label: "Price verified", passed: true),
                TrustCheck(label: "Proof available", passed: true),
            ],
            terms: [
                "Provider confirmation required.",
                "No-show may lose slot.",
                "Valid for today's open slot only.",
            ],
            urgency: "High — 2 slots left",
            preferredTime: "Today, 2:00 PM",
            budget: "$25 – $35",
            serviceArea: "0.8 mi — McAllen, TX",
            autopilotNextStep: "SOURCE will request slot confirmation.",
            providerNextAction: "Provider confirms or declines the 2 PM slot."
        ),
        SourceMatchItem(
            id: "src_hvac",
            merchantName: "RapidCool HVAC",
            category: .homeService,
            headline: "AC Diagnostic Today — $49",
            description: "Same-day AC diagnostic visit with flat-fee inspection.",
            value: "Same-day diagnostic",
            price: "$49 flat",
            countdown: "Today only",
            matchScore: 86,
            matchReason: "Your area has high heat today and this provider has same-day route availability.",
            trustScore: 90,
            trustChecks: [
                TrustCheck(label: "Verified business", passed: true),
                TrustCheck(label: "Clear terms", passed: true),
                TrustCheck(label: "Price verified", passed: true),
                TrustCheck(label: "Proof available", passed: false),
            ],
            terms: [
                "Diagnostic only.",
                "Repairs quoted before work starts.",
                "Provider confirmation required.",
            ],
            urgency: "High — same-day",
            preferredTime: "Today, afternoon",
            budget: "$49 diagnostic",
            serviceArea: "Within 5 mi service zone",
            autopilotNextStep: "SOURCE will send your service request to the provider.",
            providerNextAction: "Provider confirms route window and arrival time."
        ),
        SourceMatchItem(
            id: "src_plumbing",
            merchantName: "PipeFix Plumbing",
            category: .homeService,
            headline: "Leak Check — Same Day",
            description: "Same-day leak inspection with upfront quote.",
            value: "Starting at $99",
            price: "From $99",
            countdown: "3 openings left",
            matchScore: 88,
            matchReason: "You selected urgent home services and this provider confirms same-day jobs.",
            trustScore: 92,
            trustChecks: [
                TrustCheck(label: "Verified business", passed: true),
                TrustCheck(label: "Clear terms", passed: true),
                TrustCheck(label: "Price verified", passed: true),
                TrustCheck(label: "Proof available", passed: true),
            ],
            terms: [
                "Final price depends on inspection.",
                "Quote required before work.",
                "Provider confirms arrival window.",
            ],
            urgency: "Medium — 3 openings",
            preferredTime: "Today or tomorrow morning",
            budget: "$99+",
            serviceArea: "Within 8 mi service zone",
            autopilotNextStep: "SOURCE will ask provider to confirm arrival window.",
            providerNextAction: "Provider proposes a 2-hour arrival window."
        ),
        SourceMatchItem(
            id: "src_junk",
            merchantName: "CleanHaul Junk Removal",
            category: .homeService,
            headline: "Junk Removal — $150 Flat Rate",
            description: "Flat rate hauling up to a quarter truck.",
            value: "Flat rate up to 1/4 truck",
            price: "$150",
            countdown: "Ends today",
            matchScore: 92,
            matchReason: "You showed interest in home clean-up and this provider covers your zip code.",
            trustScore: 94,
            trustChecks: [
                TrustCheck(label: "Verified business", passed: true),
                TrustCheck(label: "Clear terms", passed: true),
                TrustCheck(label: "Price verified", passed: true),
                TrustCheck(label: "Proof available", passed: true),
            ],
            terms: [
                "Flat rate includes up to 1/4 truck.",
                "Extra volume quoted first.",
                "Pickup proof required.",
            ],
            urgency: "Medium — ends today",
            preferredTime: "Today, afternoon",
            budget: "$150 flat",
            serviceArea: "Your zip code",
            autopilotNextStep: "SOURCE will prepare a removal request. Photo upload comes in a later version.",
            providerNextAction: "Provider confirms pickup window and crew."
        ),
    ]
}
