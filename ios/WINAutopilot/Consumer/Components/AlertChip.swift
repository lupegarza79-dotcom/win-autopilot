import SwiftUI

struct AlertChip: View {
    let alert: ConsumerAlert

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(ConsumerColors.greenSoft)
                Image(systemName: alert.category.symbolName)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(ConsumerColors.green)
            }
            .frame(width: 34, height: 34)

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
