import SwiftUI

enum Countdown {
    static func urgencyColor(minutesLeft: Int) -> Color {
        if minutesLeft <= 10 { return AppColors.danger }
        if minutesLeft <= 30 { return AppColors.amber }
        return AppColors.neonGreen
    }

    static func format(seconds totalSeconds: Int) -> String {
        let m = max(0, totalSeconds) / 60
        let s = max(0, totalSeconds) % 60
        return String(format: "%02d:%02d", m, s)
    }
}
