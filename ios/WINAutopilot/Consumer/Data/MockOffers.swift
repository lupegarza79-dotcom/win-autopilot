import Foundation

enum MockOffers {
    static let all: [ConsumerOffer] = [
        ConsumerOffer(
            id: "o1",
            category: .tacos,
            businessName: "Don Pepe Tacos",
            dealText: "2×1 on Any Order",
            shortDeal: "2×1 Tacos",
            distance: "0.3 mi",
            walkTime: "~4 min walk",
            spotsLeft: 18,
            spotsTotal: 25,
            countdownMinutes: 89,
            pin: "482913",
            matchScore: 98,
            matchReason: "You claimed tacos 4 Tuesdays in a row",
            gradientStart: "#061210",
            gradientEnd: "#0C2018"
        ),
        ConsumerOffer(
            id: "o2",
            category: .coffee,
            businessName: "La Paloma Coffee",
            dealText: "FREE Large Coffee",
            shortDeal: "FREE Coffee",
            distance: "0.8 mi",
            walkTime: "~10 min walk",
            spotsLeft: 8,
            spotsTotal: 20,
            countdownMinutes: 44,
            pin: "371204",
            matchScore: 91,
            matchReason: "You buy coffee here 3x a week",
            gradientStart: "#060A14",
            gradientEnd: "#0A1428"
        ),
        ConsumerOffer(
            id: "o3",
            category: .gas,
            businessName: "XPress Gas",
            dealText: "Gas at $2.89/gal",
            shortDeal: "Gas $2.89",
            distance: "1.2 mi",
            walkTime: "~4 min drive",
            spotsLeft: 30,
            spotsTotal: 50,
            countdownMinutes: 180,
            pin: "904731",
            matchScore: 84,
            matchReason: "You fill up on Tuesdays near here",
            gradientStart: "#100A04",
            gradientEnd: "#1A1008"
        ),
        ConsumerOffer(
            id: "o4",
            category: .haircut,
            businessName: "ProCuts McAllen",
            dealText: "20% OFF Any Cut",
            shortDeal: "20% Haircut",
            distance: "0.6 mi",
            walkTime: "~8 min walk",
            spotsLeft: 3,
            spotsTotal: 10,
            countdownMinutes: 22,
            pin: "157823",
            matchScore: 76,
            matchReason: "You saved this last week",
            gradientStart: "#0A0414",
            gradientEnd: "#140820"
        )
    ]
}
