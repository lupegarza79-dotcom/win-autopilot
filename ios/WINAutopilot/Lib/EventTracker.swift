import Foundation

nonisolated enum EventTracker {
    static func track(_ name: EventName, payload: [String: String] = [:]) {
        print("[WIN EVENT]", name.rawValue, payload)
    }
}
