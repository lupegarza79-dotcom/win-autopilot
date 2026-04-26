import SwiftUI

struct AlertsScreen: View {
    @Environment(\.dismiss) private var dismiss
    let alerts: [ConsumerAlert]

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ConsumerColors.bgWarm.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("My Alerts")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundStyle(ConsumerColors.textDark)
                        Text("WIN finds it for you.")
                            .font(.system(size: 14))
                            .foregroundStyle(ConsumerColors.textMid)
                    }
                    .padding(.top, 8)

                    sectionHeader("WHAT WIN KNOWS ABOUT YOU")
                    VStack(spacing: 10) {
                        knowsRow(emoji: "🌮", text: "Tacos on Tuesdays at lunch")
                        knowsRow(emoji: "☕", text: "Coffee on weekday mornings")
                        knowsRow(emoji: "⛽", text: "Gas near home")
                    }

                    sectionHeader("WIN IS WATCHING FOR")
                    VStack(spacing: 10) {
                        ForEach(alerts) { alert in
                            AlertChip(alert: alert)
                        }
                    }

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                .padding(.bottom, 40)
            }

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(ConsumerColors.textDark)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(ConsumerColors.bgCard))
                    .overlay(Circle().strokeBorder(ConsumerColors.borderLight, lineWidth: 1))
            }
            .padding(.top, 16)
            .padding(.trailing, 16)
        }
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .heavy))
            .tracking(1.4)
            .foregroundStyle(ConsumerColors.textMuted)
    }

    private func knowsRow(emoji: String, text: String) -> some View {
        HStack(spacing: 12) {
            Text(emoji).font(.system(size: 18))
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(ConsumerColors.textDark)
            Spacer()
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14).fill(ConsumerColors.bgCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14).strokeBorder(ConsumerColors.borderLight, lineWidth: 1)
        )
    }
}
