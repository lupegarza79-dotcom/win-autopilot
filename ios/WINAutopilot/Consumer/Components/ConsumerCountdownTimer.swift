import SwiftUI

struct ConsumerCountdownTimer: View {
    let totalMinutes: Int
    @State private var secondsLeft: Int
    @State private var timer: Timer?

    init(totalMinutes: Int) {
        self.totalMinutes = totalMinutes
        self._secondsLeft = State(initialValue: max(0, totalMinutes * 60))
    }

    private var color: Color {
        let minutesLeft = secondsLeft / 60
        if minutesLeft <= 10 { return Color(red: 1.0, green: 0.39, blue: 0.39) }
        if minutesLeft <= 30 { return ConsumerColors.amber }
        return ConsumerColors.greenNeon
    }

    private var formatted: String {
        let m = secondsLeft / 60
        let s = secondsLeft % 60
        return String(format: "%02d:%02d", m, s)
    }

    var body: some View {
        Text(formatted)
            .font(.system(size: 28, weight: .heavy, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(color)
            .animation(.easeInOut(duration: 0.3), value: color)
            .onAppear {
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    Task { @MainActor in
                        if secondsLeft > 0 { secondsLeft -= 1 }
                    }
                }
            }
            .onDisappear { timer?.invalidate() }
    }
}
