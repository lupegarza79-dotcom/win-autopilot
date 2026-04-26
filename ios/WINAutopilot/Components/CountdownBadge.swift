import SwiftUI

struct CountdownBadge: View {
    let minutesLeft: Int
    var body: some View {
        let color = Countdown.urgencyColor(minutesLeft: minutesLeft)
        HStack(spacing: 6) {
            Image(systemName: "clock.fill")
                .font(.system(size: 11, weight: .bold))
            Text("\(minutesLeft) min left")
                .font(AppFont.body(12, weight: .semibold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Capsule().fill(color.opacity(0.12)))
        .overlay(Capsule().stroke(color.opacity(0.5), lineWidth: 1))
        .animation(.easeInOut(duration: 0.25), value: color)
    }
}
