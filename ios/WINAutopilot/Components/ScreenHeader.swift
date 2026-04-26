import SwiftUI

struct ScreenHeader: View {
    let title: String
    let subtitle: String?
    var rightLabel: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack(alignment: .center) {
                HStack(spacing: 6) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 14, weight: .black))
                        .foregroundStyle(AppColors.neonGreen)
                    Text("WIN")
                        .font(AppFont.display(14, weight: .heavy))
                        .tracking(2)
                        .foregroundStyle(AppColors.textWhite)
                }
                Spacer()
                if let rightLabel {
                    Text(rightLabel)
                        .font(AppFont.body(12, weight: .medium))
                        .foregroundStyle(AppColors.textMuted)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule().fill(AppColors.bgCard)
                        )
                        .overlay(Capsule().stroke(AppColors.border, lineWidth: 1))
                }
            }
            Text(title)
                .font(AppFont.display(28, weight: .heavy))
                .foregroundStyle(AppColors.textWhite)
                .padding(.top, 4)
            if let subtitle {
                Text(subtitle)
                    .font(AppFont.body(15, weight: .regular))
                    .foregroundStyle(AppColors.textMuted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
