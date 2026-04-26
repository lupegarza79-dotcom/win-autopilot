import SwiftUI

struct AlertChip: View {
    let alert: ConsumerAlert

    var body: some View {
        HStack(spacing: 12) {
            Text(alert.emoji)
                .font(.system(size: 22))
                .frame(width: 40, height: 40)
                .background(Circle().fill(ConsumerColors.bgWarm))
            VStack(alignment: .leading, spacing: 2) {
                Text(alert.label)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(ConsumerColors.textDark)
                Text("\(alert.condition) · \(alert.timeWindow)")
                    .font(.system(size: 12))
                    .foregroundStyle(ConsumerColors.textMid)
            }
            Spacer()
            Circle()
                .fill(alert.active ? ConsumerColors.green : ConsumerColors.textHint)
                .frame(width: 8, height: 8)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(ConsumerColors.bgCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(ConsumerColors.borderLight, lineWidth: 1)
        )
    }
}
