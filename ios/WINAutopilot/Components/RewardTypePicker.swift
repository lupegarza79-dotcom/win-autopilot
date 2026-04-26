import SwiftUI

struct RewardTypePicker: View {
    @Binding var selection: RewardType

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Reward Type")
                .font(AppFont.body(12, weight: .semibold))
                .tracking(1)
                .foregroundStyle(AppColors.textMuted)
            HStack(spacing: 8) {
                ForEach(RewardType.allCases) { type in
                    let selected = selection == type
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                            selection = type
                        }
                    } label: {
                        Text(type.label)
                            .font(AppFont.body(12, weight: .bold))
                            .foregroundStyle(selected ? Color.black : AppColors.textWhite)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selected ? AppColors.neonGreen : AppColors.bgDeep)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selected ? Color.clear : AppColors.border, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            Text(AIEngine.rewardTypeExplanation(selection))
                .font(AppFont.body(12, weight: .regular))
                .foregroundStyle(AppColors.textMuted)
                .padding(.top, 4)
        }
    }
}
