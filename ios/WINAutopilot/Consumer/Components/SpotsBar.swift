import SwiftUI

struct SpotsBar: View {
    let spotsLeft: Int
    let spotsTotal: Int

    private var progress: CGFloat {
        guard spotsTotal > 0 else { return 0 }
        return CGFloat(spotsLeft) / CGFloat(spotsTotal)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(spotsLeft) spots left")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(ConsumerColors.textLight)
                Spacer()
                Text("of \(spotsTotal)")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(ConsumerColors.textLightMuted)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.10))
                    Capsule()
                        .fill(ConsumerColors.greenNeon)
                        .frame(width: max(8, geo.size.width * progress))
                }
            }
            .frame(height: 6)
        }
    }
}
