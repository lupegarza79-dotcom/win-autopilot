import SwiftUI

struct AIContextLine: View {
    let text: String
    var isScanning: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(isScanning ? ConsumerColors.aiBlue : ConsumerColors.green)
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
                .fill(isScanning ? ConsumerColors.aiBlueSoft : ConsumerColors.bgGreen)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(isScanning ? ConsumerColors.aiBlueBorder : ConsumerColors.borderGreen, lineWidth: 1)
        )
    }
}
