import SwiftUI

enum ConsumerColors {
    static let bgWarm = Color(red: 0.976, green: 0.973, blue: 0.961)
    static let bgCard = Color.white
    static let bgDark = Color(red: 0.051, green: 0.067, blue: 0.090)
    static let bgDeep = Color(red: 0.031, green: 0.047, blue: 0.039)
    static let bgGreen = Color(red: 0.941, green: 0.984, blue: 0.961)

    static let borderLight = Color.black.opacity(0.07)
    static let borderMid = Color.black.opacity(0.12)
    static let borderGreen = Color(red: 0, green: 0.706, blue: 0.314).opacity(0.22)
    static let borderDark = Color.white.opacity(0.08)

    static let green = Color(red: 0, green: 0.784, blue: 0.392)
    static let greenNeon = Color(red: 0, green: 1.0, blue: 0.533)
    static let greenSoft = Color(red: 0, green: 0.784, blue: 0.392).opacity(0.12)

    static let amber = Color(red: 0.878, green: 0.545, blue: 0)
    static let amberSoft = Color(red: 0.878, green: 0.545, blue: 0).opacity(0.10)
    static let red = Color(red: 0.863, green: 0.196, blue: 0.275).opacity(0.70)
    static let redSoft = Color(red: 0.863, green: 0.196, blue: 0.275).opacity(0.10)

    static let textDark = Color(red: 0.051, green: 0.067, blue: 0.090)
    static let textMid = Color.black.opacity(0.55)
    static let textMuted = Color.black.opacity(0.35)
    static let textHint = Color.black.opacity(0.22)

    static let textLight = Color.white
    static let textLightMid = Color.white.opacity(0.55)
    static let textLightMuted = Color.white.opacity(0.32)
}
