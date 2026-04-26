import SwiftUI

struct GroupPackProgress: View {
    let current: Int
    let required: Int

    var body: some View {
        let progress = required > 0 ? min(1, Double(current) / Double(required)) : 0
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(current) of \(required) joined")
                    .font(AppFont.body(13, weight: .semibold))
                    .foregroundStyle(AppColors.textWhite)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(AppFont.body(12, weight: .medium))
                    .foregroundStyle(AppColors.textMuted)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(AppColors.bgDeep)
                    Capsule()
                        .fill(LinearGradient(colors: [AppColors.neonGreen, AppColors.neonBlue], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * progress)
                        .animation(.spring(response: 0.45, dampingFraction: 0.85), value: progress)
                }
            }
            .frame(height: 8)
        }
    }
}
