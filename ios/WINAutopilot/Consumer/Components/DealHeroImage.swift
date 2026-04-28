import SwiftUI

struct DealHeroImage: View {
    let offer: ConsumerOffer
    var height: CGFloat = 160

    private var fallback: some View {
        ZStack {
            categoryGradient(for: offer.category)
            Image(systemName: offer.category.symbolName)
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(.white.opacity(0.35))
        }
    }

    private func categoryGradient(for category: ConsumerCategory) -> LinearGradient {
        switch category {
        case .tacos:
            LinearGradient(colors: [Color(red: 0.22, green: 0.36, blue: 0.16), Color(red: 0.12, green: 0.24, blue: 0.11)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .coffee:
            LinearGradient(colors: [Color(red: 0.35, green: 0.22, blue: 0.10), Color(red: 0.20, green: 0.12, blue: 0.06)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .gas:
            LinearGradient(colors: [Color(red: 0.10, green: 0.22, blue: 0.38), Color(red: 0.06, green: 0.14, blue: 0.24)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .haircut:
            LinearGradient(colors: [Color(red: 0.24, green: 0.14, blue: 0.36), Color(red: 0.14, green: 0.08, blue: 0.22)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .pizza:
            LinearGradient(colors: [Color(red: 0.38, green: 0.16, blue: 0.10), Color(red: 0.24, green: 0.10, blue: 0.06)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .carwash:
            LinearGradient(colors: [Color(red: 0.10, green: 0.20, blue: 0.36), Color(red: 0.06, green: 0.12, blue: 0.22)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    // TODO Production:
    // Cache merchant images and prefetch top 3 candidate offers before showing card to prevent flicker.

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
                    colors: [Color.black.opacity(0.0), Color.black.opacity(0.72)],
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
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.black.opacity(0.50)))
                .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.white.opacity(0.18), lineWidth: 1))
                .padding(12)
            }
    }
}
