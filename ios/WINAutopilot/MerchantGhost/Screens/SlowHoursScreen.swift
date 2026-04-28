import SwiftUI

struct SlowHoursScreen: View {
    @Bindable var store: GhostStore
    let onContinue: () -> Void

    @State private var day: WeekDay = .tue
    @State private var startHour: Int = 14
    @State private var endHour: Int = 16
    @State private var discountAllowed: Bool = true

    var body: some View {
        ScrollView {
            VStack(spacing: ConsumerSpacing.md) {
                GhostHeader(
                    step: 2, total: 5,
                    title: "When do you need traffic?",
                    subtitle: "WIN activates offers when you actually need demand."
                )

                GhostCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("DAY OF WEEK")
                            .font(.system(size: 11, weight: .heavy))
                            .tracking(0.6)
                            .foregroundStyle(ConsumerColors.textMid)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(WeekDay.allCases) { d in
                                    GhostTagChip(label: d.rawValue, selected: day == d) { day = d }
                                }
                            }
                        }
                        .contentMargins(.horizontal, 0)
                    }

                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("START")
                                .font(.system(size: 11, weight: .heavy))
                                .tracking(0.6)
                                .foregroundStyle(ConsumerColors.textMid)
                            Picker("Start", selection: $startHour) {
                                ForEach(0..<24, id: \.self) { Text(formatHour($0)).tag($0) }
                            }
                            .pickerStyle(.menu)
                            .tint(ConsumerColors.textDark)
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            Text("END")
                                .font(.system(size: 11, weight: .heavy))
                                .tracking(0.6)
                                .foregroundStyle(ConsumerColors.textMid)
                            Picker("End", selection: $endHour) {
                                ForEach(1..<25, id: \.self) { Text(formatHour($0 % 24)).tag($0 % 24) }
                            }
                            .pickerStyle(.menu)
                            .tint(ConsumerColors.textDark)
                        }
                    }

                    Toggle(isOn: $discountAllowed) {
                        Text("Discounts allowed in this window")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(ConsumerColors.textDark)
                    }
                    .tint(ConsumerColors.green)

                    Button {
                        let s = min(startHour, endHour)
                        let e = max(startHour, endHour)
                        guard s != e else { return }
                        store.addSlowHour(SlowHour(day: day, startHour: s, endHour: e, discountAllowed: discountAllowed))
                    } label: {
                        Text("Add Slow Window")
                            .font(.system(size: 14, weight: .heavy))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(ConsumerColors.greenNeon)
                            .clipShape(.rect(cornerRadius: ConsumerSpacing.radiusBtn))
                    }
                }
                .padding(.horizontal, ConsumerSpacing.screen)

                if !store.slowHours.isEmpty {
                    GhostCard {
                        Text("YOUR SLOW WINDOWS")
                            .font(.system(size: 11, weight: .heavy))
                            .tracking(0.6)
                            .foregroundStyle(ConsumerColors.textMid)
                        ForEach(store.slowHours) { hour in
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundStyle(ConsumerColors.aiBlue)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(hour.label)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(ConsumerColors.textDark)
                                    Text(hour.discountAllowed ? "Discounts allowed" : "No discounts")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundStyle(ConsumerColors.textMid)
                                }
                                Spacer()
                                Button {
                                    store.removeSlowHour(hour.id)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(ConsumerColors.red)
                                }
                            }
                            .padding(.vertical, 6)
                            if hour.id != store.slowHours.last?.id {
                                Divider().background(ConsumerColors.borderLight)
                            }
                        }
                    }
                    .padding(.horizontal, ConsumerSpacing.screen)
                }

                Spacer(minLength: 12)

                GhostPrimaryButton(
                    title: "Continue to Margin Guard",
                    enabled: !store.slowHours.isEmpty
                ) {
                    onContinue()
                }

                Spacer(minLength: 24)
            }
        }
        .background(ConsumerColors.bgWarm)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formatHour(_ h: Int) -> String {
        let hour12 = ((h + 11) % 12) + 1
        let suffix = h < 12 ? "AM" : "PM"
        return "\(hour12):00 \(suffix)"
    }
}
