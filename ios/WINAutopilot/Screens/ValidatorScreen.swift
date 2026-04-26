import SwiftUI

struct ValidatorScreen: View {
    @Environment(AppState.self) private var state
    @State private var pin: String = ""
    @State private var ticket: String = ""
    @State private var validated = false
    @State private var error = false
    @State private var shake: CGFloat = 0
    @FocusState private var pinFocus: Bool

    var body: some View {
        ZStack {
            AppColors.bgMain.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    ScreenHeader(
                        title: "Validate Redemption",
                        subtitle: "Scan QR or enter PIN to redeem.",
                        rightLabel: "Step 4 / 5"
                    )

                    scanner

                    pinCard

                    ticketCard

                    if validated {
                        validatedCard
                        PrimaryButton(title: "Mark as Redeemed", icon: "checkmark.seal.fill") {
                            redeem()
                        }
                    } else {
                        PrimaryButton(title: "Validate PIN", icon: "lock.shield.fill", disabled: pin.count < 4) {
                            validate()
                        }
                    }
                }
                .padding(.horizontal, Spacing.screenPadding)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
    }

    private var scanner: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: Spacing.radius)
                    .fill(AppColors.bgDeep)
                RoundedRectangle(cornerRadius: Spacing.radius)
                    .stroke(AppColors.neonGreen.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [10, 8]))
                VStack(spacing: 8) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.system(size: 56, weight: .light))
                        .foregroundStyle(AppColors.neonGreen)
                    Text("Point camera at customer's QR")
                        .font(AppFont.body(12, weight: .medium))
                        .foregroundStyle(AppColors.textMuted)
                }
            }
            .frame(height: 200)
        }
    }

    private var pinCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("OR ENTER PIN")
                .font(AppFont.body(10, weight: .heavy))
                .tracking(1.5)
                .foregroundStyle(AppColors.textMuted)
            TextField("------", text: $pin)
                .keyboardType(.numberPad)
                .focused($pinFocus)
                .font(AppFont.mono(28, weight: .heavy))
                .foregroundStyle(error ? AppColors.danger : AppColors.textWhite)
                .multilineTextAlignment(.center)
                .padding(.vertical, 16)
                .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.bgCard))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(error ? AppColors.danger : AppColors.border, lineWidth: 1)
                )
                .offset(x: shake)
                .onChange(of: pin) { _, _ in
                    if error { withAnimation { error = false } }
                }
            if error {
                Text("Invalid or expired PIN.")
                    .font(AppFont.body(12, weight: .semibold))
                    .foregroundStyle(AppColors.danger)
            }
        }
    }

    private var ticketCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TICKET AMOUNT (OPTIONAL)")
                .font(AppFont.body(10, weight: .heavy))
                .tracking(1.5)
                .foregroundStyle(AppColors.textMuted)
            HStack {
                Text("$")
                    .font(AppFont.display(18, weight: .heavy))
                    .foregroundStyle(AppColors.textMuted)
                TextField("0", text: $ticket)
                    .keyboardType(.decimalPad)
                    .font(AppFont.body(18, weight: .bold))
                    .foregroundStyle(AppColors.textWhite)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.bgCard))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.border, lineWidth: 1))
        }
    }

    private var validatedCard: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(AppColors.neonGreen)
            VStack(alignment: .leading, spacing: 2) {
                Text("Valid PIN")
                    .font(AppFont.display(18, weight: .heavy))
                    .foregroundStyle(AppColors.neonGreen)
                Text("Tap below to confirm redemption.")
                    .font(AppFont.body(12, weight: .medium))
                    .foregroundStyle(AppColors.textMuted)
            }
            Spacer()
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Spacing.radius).fill(AppColors.neonGreen.opacity(0.08)))
        .overlay(RoundedRectangle(cornerRadius: Spacing.radius).stroke(AppColors.neonGreen.opacity(0.5), lineWidth: 1))
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }

    private func validate() {
        if pin == MockData.validPin {
            EventTracker.track(.PIN_VALIDATED)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                validated = true
                error = false
            }
            pinFocus = false
        } else {
            withAnimation(.default) { error = true }
            shakePin()
        }
    }

    private func shakePin() {
        let baseline: CGFloat = 0
        withAnimation(.linear(duration: 0.05)) { shake = -10 }
        Task { @MainActor in
            for offset in [10.0, -8.0, 8.0, -4.0, 4.0, baseline] {
                try? await Task.sleep(for: .milliseconds(50))
                withAnimation(.linear(duration: 0.05)) { shake = CGFloat(offset) }
            }
        }
    }

    private func redeem() {
        let amount = Double(ticket)
        state.redeem(ticket: amount)
        EventTracker.track(.OFFER_REDEEMED)
        state.showToast("Redeemed. Campaign data updated.")
        withAnimation(.spring()) {
            validated = false
            pin = ""
            ticket = ""
        }
    }
}
