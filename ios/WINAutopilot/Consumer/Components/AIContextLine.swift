import SwiftUI

struct AIContextLine: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(ConsumerColors.green)
                .frame(width: 6, height: 6)
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(ConsumerColors.textMid)
                .lineLimit(2)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(ConsumerColors.bgGreen)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(ConsumerColors.borderGreen, lineWidth: 1)
        )
    }
}
