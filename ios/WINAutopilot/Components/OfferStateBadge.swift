import SwiftUI

struct OfferStateBadge: View {
    let status: OfferStatus

    var body: some View {
        let (label, color): (String, Color) = {
            switch status {
            case .now: return ("LIVE NOW", AppColors.neonGreen)
            case .upcoming: return ("UPCOMING", AppColors.neonBlue)
            case .expired: return ("EXPIRED", AppColors.danger)
            }
        }()
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 7, height: 7)
            Text(label)
                .font(AppFont.body(11, weight: .heavy))
                .tracking(1.2)
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Capsule().fill(color.opacity(0.12)))
        .overlay(Capsule().stroke(color.opacity(0.4), lineWidth: 1))
    }
}
