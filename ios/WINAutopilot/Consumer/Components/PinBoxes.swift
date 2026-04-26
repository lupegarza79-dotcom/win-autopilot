import SwiftUI

struct PinBoxes: View {
    let pin: String

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(pin.enumerated()), id: \.offset) { _, ch in
                Text(String(ch))
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundStyle(ConsumerColors.textDark)
                    .frame(width: 40, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(ConsumerColors.bgWarm)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(ConsumerColors.borderMid, lineWidth: 1)
                    )
            }
        }
    }
}
