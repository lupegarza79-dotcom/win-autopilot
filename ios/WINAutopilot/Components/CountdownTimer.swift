import SwiftUI

struct CountdownTimer: View {
    let totalMinutes: Int
    @State private var secondsLeft: Int = 0
    @State private var timer: Timer? = nil

    var body: some View {
        let minutesLeft = max(0, secondsLeft / 60)
        let color = Countdown.urgencyColor(minutesLeft: minutesLeft)
        HStack(spacing: 12) {
            Image(systemName: "clock.fill")
                .foregroundStyle(color)
                .font(.system(size: 16, weight: .bold))
            Text(Countdown.format(seconds: secondsLeft))
                .font(AppFont.mono(28, weight: .heavy))
                .foregroundStyle(color)
                .monospacedDigit()
                .contentTransition(.numericText())
            Spacer()
            Text("until offer ends")
                .font(AppFont.body(12, weight: .medium))
                .foregroundStyle(AppColors.textMuted)
        }
        .padding(Spacing.cardPadding)
        .background(RoundedRectangle(cornerRadius: Spacing.radius).fill(AppColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: Spacing.radius).stroke(color.opacity(0.4), lineWidth: 1))
        .animation(.easeInOut(duration: 0.3), value: color)
        .onAppear {
            secondsLeft = totalMinutes * 60
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                Task { @MainActor in
                    if secondsLeft > 0 { secondsLeft -= 1 }
                }
            }
        }
        .onDisappear { timer?.invalidate(); timer = nil }
    }
}
