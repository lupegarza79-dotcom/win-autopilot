import SwiftUI

struct DealCard: View {
    let offer: ConsumerOffer
    @Binding var isFlipped: Bool
    var dragOffset: CGSize = .zero

    private var rotation: Double {
        isFlipped ? 180 : 0
    }

    private var dragRotation: Double {
        Double(dragOffset.width / 20)
    }

    private var dragLabel: (String, Color)? {
        if dragOffset.width > 60 {
            return ("CLAIM", ConsumerColors.green)
        } else if dragOffset.width < -60 {
            return ("PASS", Color(red: 0.86, green: 0.20, blue: 0.27))
        }
        return nil
    }

    var body: some View {
        ZStack {
            CardFront(offer: offer)
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))

            CardBack(offer: offer)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(rotation - 180), axis: (x: 0, y: 1, z: 0))
        }
        .overlay(alignment: .top) {
            if let label = dragLabel, !isFlipped {
                Text(label.0)
                    .font(.system(size: 28, weight: .heavy))
                    .tracking(2)
                    .foregroundStyle(label.1)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(label.1, lineWidth: 2)
                    )
                    .padding(.top, 24)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .rotationEffect(.degrees(isFlipped ? 0 : dragRotation))
        .offset(isFlipped ? .zero : dragOffset)
        .animation(.spring(response: 0.55, dampingFraction: 0.78), value: isFlipped)
    }
}
