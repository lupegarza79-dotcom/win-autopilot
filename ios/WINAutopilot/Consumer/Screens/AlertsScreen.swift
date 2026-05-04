import SwiftUI

struct AlertsScreen: View {
    @Environment(\.dismiss) private var dismiss
    let alerts: [ConsumerAlert]
    @State private var showPilotSheet = false
    @State private var pilotSubmitted = false

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

                    HStack(spacing: 8) {
                        sectionHeader("WHAT WIN KNOWS ABOUT YOU")
                        Spacer()
                        badge(text: "AI memory", color: ConsumerColors.retailBlue, bg: ConsumerColors.retailBlueSoft, border: ConsumerColors.retailBlueBorder)
                    }
                    VStack(spacing: 10) {
                        knowsRow(category: .tacos, text: "Tacos on Tuesdays at lunch")
                        knowsRow(category: .coffee, text: "Coffee on weekday mornings")
                        knowsRow(category: .gas, text: "Gas near home")
                    }

                    HStack(spacing: 8) {
                        sectionHeader("WIN IS WATCHING FOR")
                        Spacer()
                        badge(text: "Active alerts", color: ConsumerColors.green, bg: ConsumerColors.greenSoft, border: ConsumerColors.borderGreen)
                    }
                    VStack(spacing: 10) {
                        ForEach(alerts) { alert in
                            AlertChip(alert: alert)
                        }
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("These alerts train your matches.")
                            .font(.system(size: 12))
                            .foregroundStyle(ConsumerColors.textMuted)
                        Text("Reliable redemptions improve your match priority.")
                            .font(.system(size: 11))
                            .foregroundStyle(ConsumerColors.textHint)
                    }
                    .padding(.top, 2)

                    pilotCTA
                        .padding(.top, 8)

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

    private func badge(text: String, color: Color, bg: Color, border: Color) -> some View {
        Text(text)
            .font(.system(size: 9, weight: .heavy))
            .tracking(1.0)
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(bg))
            .overlay(Capsule().strokeBorder(border, lineWidth: 1))
    }

    private var pilotCTA: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "storefront.fill")
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundStyle(ConsumerColors.retailBlue)
                Text("FOR MERCHANTS")
                    .font(.system(size: 9, weight: .heavy))
                    .tracking(1.2)
                    .foregroundStyle(ConsumerColors.retailBlue)
            }

            Text("WIN helps fill slow hours.")
                .font(.system(size: 18, weight: .heavy))
                .foregroundStyle(ConsumerColors.textDark)

            Text("You only pay when a customer is generated. No setup fees. No monthly cost.")
                .font(.system(size: 13))
                .foregroundStyle(ConsumerColors.textMid)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                showPilotSheet = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 12, weight: .heavy))
                    Text("Join Pilot")
                        .font(.system(size: 14, weight: .heavy))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [ConsumerColors.retailBlue, ConsumerColors.retailBlue.opacity(0.85)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(PressScaleStyle())
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(ConsumerColors.retailBlueSoft))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(ConsumerColors.retailBlueBorder, lineWidth: 1))
        .sheet(isPresented: $showPilotSheet) {
            PilotConfirmSheet(submitted: $pilotSubmitted)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }

    private func knowsRow(category: ConsumerCategory, text: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(ConsumerColors.retailBlueSoft)
                Image(systemName: category.symbolName)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(ConsumerColors.retailBlue)
            }
            .frame(width: 34, height: 34)
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
