import SwiftUI

struct StatCard: View {
    let value: String
    let label: String
    var accent: Color = AppColors.textWhite
    var icon: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(accent.opacity(0.9))
            }
            Text(value)
                .font(AppFont.display(24, weight: .heavy))
                .foregroundStyle(accent)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(AppFont.body(12, weight: .medium))
                .foregroundStyle(AppColors.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: Spacing.radius).fill(AppColors.bgCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Spacing.radius).stroke(AppColors.border, lineWidth: 1)
        )
    }
}
