import Foundation

enum MockData {
    static let business = Business(
        name: "Don Pepe Tacos",
        category: "Restaurant",
        address: "McAllen, TX",
        phone: "(956) 555-0188",
        whatsapp: "9565550188",
        averageTicket: 18,
        slowHours: "2:00 PM - 4:00 PM",
        bestItems: ["Taco Combo", "Large Drink", "Quesadilla"],
        highMarginItems: ["Large Drink", "Chips & Salsa", "Dessert"],
        maxRedemptions: 25
    )

    static let offer = Offer(
        id: "offer_001",
        type: .percent_off,
        title: "20% OFF Taco Combo",
        description: "Bring more traffic during slow hours. Valid today from 2 PM to 4 PM.",
        whyAIPicked: "Your slow window is 2–4 PM. This offer uses a popular item but limits spots to protect your margin.",
        timeWindow: "2:00 PM - 4:00 PM",
        countdownMinutes: 90,
        maxRedemptions: 25,
        spotsLeft: 18,
        estimatedSalesMin: 150,
        estimatedSalesMax: 350,
        terms: "Valid today only. One per customer. Dine-in or pickup. Cannot combine with other offers.",
        whatsappMessage: "🔥 Don Pepe Tacos has 20% OFF Taco Combo today from 2–4 PM. Only 18 spots left! Tap to reserve yours before it expires.",
        publicLink: "win.app/o/don-pepe-tacos-20off",
        pin: "482913",
        status: .now,
        startsAt: "2:00 PM",
        endsAt: "4:00 PM",
        distance: "0.3 mi",
        proximityLabel: "You are very close"
    )

    static let upcomingOffer: Offer = {
        var o = offer
        o.id = "offer_002"
        o.type = .free_add_on
        o.title = "FREE Chips & Salsa with any combo"
        o.status = .upcoming
        o.startsAt = "8:00 PM"
        o.endsAt = "9:30 PM"
        o.distance = "0.8 mi"
        o.proximityLabel = "You are nearby"
        o.countdownMinutes = 0
        o.spotsLeft = 20
        return o
    }()

    static let stats = CampaignStats(
        views: 126,
        shares: 18,
        going: 24,
        redeemed: 11,
        noShows: 6,
        estimatedSales: 198,
        averageTicket: 18,
        winFee: 19.8
    )

    static let groupPack = GroupPack(
        id: "pack_001",
        packType: "pay_3_get_5",
        title: "Pay 3, Get 5 Taco Combos",
        description: "Get 5 Taco Combos for the price of 3. Pickup window: 3–4 PM only.",
        requiredPeople: 5,
        currentPeople: 2,
        pickupWindow: "3:00 PM - 4:00 PM",
        packPrice: 30,
        packValue: 45,
        savings: 15,
        shareMessage: "Join my WIN Pack at Don Pepe Tacos! Pay 3, Get 5 Taco Combos. Pickup 3–4 PM.",
        status: .open,
        countdownMinutes: 45
    )

    static let validPin = "482913"
}
