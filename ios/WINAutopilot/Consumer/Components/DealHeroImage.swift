import SwiftUI

struct DealHeroImage: View {
    let offer: ConsumerOffer
    var height: CGFloat = 160

    private func hex(_ s: String) -> Color {
        var v: UInt64 = 0
        Scanner(string: s.replacingOccurrences(of: "#", with: "")).scanHexInt64(&v)
        let r = Double((v >> 16) & 0xff) / 255
        let g = Double((v >> 8) & 0xff) / 255
        let b = Double(v & 0xff) / 255
        return Color(red: r, green: g, blue: b)
    }

    private var fallback: some View {
        ZStack {
            LinearGradient(
                colors: [hex(offer.gradientStart), hex(offer.gradientEnd)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image(systemName: offer.category.symbolName)
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(.white.opacity(0.35))
        }
    }

    var body: some View {
        Color.black.opacity(0.2)
            .frame(height: height)
            .overlay {
                AsyncImage(url: URL(string: offer.imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .allowsHitTesting(false)
                    case .empty, .failure:
                        fallback.allowsHitTesting(false)
                    @unknown default:
                        fallback.allowsHitTesting(false)
                    }
                }
            }
            .overlay {
                LinearGradient(
                    colors: [Color.black.opacity(0.05), Color.black.opacity(0.65)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .allowsHitTesting(false)
            }
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .overlay(alignment: .bottomLeading) {
                HStack(spacing: 8) {
                    Image(systemName: offer.category.symbolName)
                        .font(.system(size: 11, weight: .bold))
                    Text(offer.businessName)
                        .font(.system(size: 12, weight: .semibold))
                        .lineLimit(1)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Capsule().fill(.ultraThinMaterial))
                .overlay(Capsule().strokeBorder(Color.white.opacity(0.18), lineWidth: 1))
                .padding(12)
            }
    }
}
