import Foundation

enum MockUser {
    static let behavior = UserBehavior()

    static let alerts: [ConsumerAlert] = [
        ConsumerAlert(id: "a1", category: .tacos, emoji: "🌮", label: "Tacos",
                      condition: "2×1 or better", timeWindow: "Anytime", active: true),
        ConsumerAlert(id: "a2", category: .coffee, emoji: "☕", label: "Coffee",
                      condition: "Any free offer", timeWindow: "Mornings only", active: true),
        ConsumerAlert(id: "a3", category: .gas, emoji: "⛽", label: "Gas",
                      condition: "Under $3.00", timeWindow: "Anytime", active: true)
    ]
}
