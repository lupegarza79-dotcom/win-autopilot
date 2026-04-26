import SwiftUI

struct MerchantSetupScreen: View {
    @Environment(AppState.self) private var state
    var switchTab: (AppTab) -> Void

    @State private var name: String = MockData.business.name
    @State private var category: String = MockData.business.category
    @State private var address: String = MockData.business.address
    @State private var phone: String = MockData.business.phone
    @State private var avgTicket: String = "\(Int(MockData.business.averageTicket))"
    @State private var slowHours: String = MockData.business.slowHours
    @State private var bestItem: String = MockData.business.bestItems.first ?? ""
    @State private var marginItem: String = MockData.business.highMarginItems.first ?? ""
    @State private var maxRedemptions: String = "\(MockData.business.maxRedemptions)"

    var body: some View {
        ZStack {
            AppColors.bgMain.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    ScreenHeader(
                        title: "Set up your revenue autopilot",
                        subtitle: "Tell WIN when you are slow. AI will suggest the best offer.",
                        rightLabel: "Step 1 / 5"
                    )

                    tagline

                    VStack(spacing: Spacing.cardGap) {
                        field("Business name", text: $name, icon: "storefront.fill")
                        field("Category", text: $category, icon: "tag.fill")
                        field("Address / city", text: $address, icon: "mappin.and.ellipse")
                        field("Phone / WhatsApp", text: $phone, icon: "phone.fill", keyboard: .phonePad)
                        field("Average ticket ($)", text: $avgTicket, icon: "dollarsign.circle.fill", keyboard: .numberPad)
                        field("Slow hours", text: $slowHours, icon: "clock.fill")
                        field("Best-selling item", text: $bestItem, icon: "star.fill")
                        field("High-margin item", text: $marginItem, icon: "chart.line.uptrend.xyaxis")
                        field("Max redemptions", text: $maxRedemptions, icon: "person.3.fill", keyboard: .numberPad)
                    }

                    exampleCard

                    PrimaryButton(title: "Generate My First Promo", icon: "sparkles") {
                        save()
                    }

                    Text("Only pay when WIN brings results.")
                        .font(AppFont.body(12, weight: .medium))
                        .foregroundStyle(AppColors.textHint)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 4)
                }
                .padding(.horizontal, Spacing.screenPadding)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
    }

    private var tagline: some View {
        HStack(spacing: 8) {
            Image(systemName: "bolt.fill")
                .foregroundStyle(AppColors.neonGreen)
            Text("Turn slow hours into paid traffic.")
                .font(AppFont.body(13, weight: .semibold))
                .foregroundStyle(AppColors.textWhite)
            Spacer()
            Text("No ads. Only rewards.")
                .font(AppFont.body(11, weight: .medium))
                .foregroundStyle(AppColors.textMuted)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.neonGreen.opacity(0.08)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.neonGreen.opacity(0.3), lineWidth: 1))
    }

    private func field(_ label: String, text: Binding<String>, icon: String, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon).foregroundStyle(AppColors.neonGreen).font(.system(size: 11, weight: .bold))
                Text(label)
                    .font(AppFont.body(11, weight: .semibold))
                    .tracking(0.8)
                    .foregroundStyle(AppColors.textMuted)
            }
            TextField("", text: text)
                .keyboardType(keyboard)
                .autocorrectionDisabled()
                .foregroundStyle(AppColors.textWhite)
                .font(AppFont.body(15, weight: .medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.bgCard))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColors.border, lineWidth: 1))
        }
    }

    private var exampleCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(AppColors.amber)
                Text("EXAMPLE")
                    .font(AppFont.body(10, weight: .heavy))
                    .tracking(1.5)
                    .foregroundStyle(AppColors.amber)
            }
            Text("If Tuesday 2–4 PM is slow, WIN can create a limited-time offer for that window only.")
                .font(AppFont.body(13, weight: .medium))
                .foregroundStyle(AppColors.textWhite)
                .lineSpacing(2)
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Spacing.radius).fill(AppColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: Spacing.radius).stroke(AppColors.amber.opacity(0.25), lineWidth: 1))
    }

    private func save() {
        state.business.name = name
        state.business.category = category
        state.business.address = address
        state.business.phone = phone
        state.business.whatsapp = phone
        state.business.averageTicket = Double(avgTicket) ?? state.business.averageTicket
        state.business.slowHours = slowHours
        state.business.bestItems = [bestItem] + state.business.bestItems.dropFirst()
        state.business.highMarginItems = [marginItem] + state.business.highMarginItems.dropFirst()
        state.business.maxRedemptions = Int(maxRedemptions) ?? state.business.maxRedemptions

        EventTracker.track(.BUSINESS_CREATED, payload: ["name": name])
        let p = AIEngine.generatePromo(business: state.business)
        state.applyGenerated(p)
        EventTracker.track(.OFFER_GENERATED)
        state.showToast("AI created your first promo.")
        switchTab(.builder)
    }
}
