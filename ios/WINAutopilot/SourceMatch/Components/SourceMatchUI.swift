import SwiftUI

// MARK: - REAiL Trust Badge

struct REAiLTrustBadge: View {
    let score: Int
    var compact: Bool = false

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: compact ? 10 : 12, weight: .bold))
                .foregroundStyle(SourceColors.trustGold)
            VStack(alignment: .leading, spacing: 0) {
                if !compact {
                    Text("REAiL")
                        .font(.system(size: 8, weight: .heavy))
                        .tracking(1.0)
                        .foregroundStyle(SourceColors.trustGold)
                }
                Text("\(score) Trust")
                    .font(.system(size: compact ? 10 : 12, weight: .heavy))
                    .foregroundStyle(SourceColors.textPrimary)
            }
        }
        .padding(.horizontal, compact ? 8 : 10)
        .padding(.vertical, compact ? 4 : 6)
        .background(Capsule().fill(SourceColors.trustGoldSoft))
        .overlay(Capsule().strokeBorder(SourceColors.trustGold.opacity(0.4), lineWidth: 1))
    }
}

// MARK: - Why Matched

struct WhyMatchedView: View {
    let reason: String
    let matchScore: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(SourceColors.aiBlue)
                Text("WHY THIS MATCHED")
                    .font(.system(size: 9, weight: .heavy))
                    .tracking(1.0)
                    .foregroundStyle(SourceColors.aiBlue)
                Spacer(minLength: 0)
                Text("\(matchScore)% match")
                    .font(.system(size: 10, weight: .heavy))
                    .foregroundStyle(SourceColors.success)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(SourceColors.success.opacity(0.14)))
            }
            Text(reason)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(SourceColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 14).fill(SourceColors.aiBlueSoft))
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(SourceColors.aiBlue.opacity(0.28), lineWidth: 1))
    }
}

// MARK: - Trust checklist

struct TrustChecklistView: View {
    let checks: [TrustCheck]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(checks) { check in
                HStack(spacing: 8) {
                    Image(systemName: check.passed ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(check.passed ? SourceColors.success : SourceColors.urgency)
                    Text(check.label)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(SourceColors.textSecondary)
                    Spacer(minLength: 0)
                }
            }
        }
    }
}

// MARK: - Countdown badge

struct SourceCountdownBadge: View {
    let text: String

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "clock.fill")
                .font(.system(size: 10, weight: .bold))
            Text(text)
                .font(.system(size: 11, weight: .heavy))
        }
        .foregroundStyle(SourceColors.urgency)
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background(Capsule().fill(SourceColors.urgency.opacity(0.14)))
        .overlay(Capsule().strokeBorder(SourceColors.urgency.opacity(0.4), lineWidth: 1))
    }
}

// MARK: - Source Match Card

struct SourceMatchCard: View {
    let item: SourceMatchItem
    var dragOffset: CGSize = .zero

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Hero
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    colors: [item.category.accent.opacity(0.85), item.category.accent.opacity(0.45)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 150)

                LinearGradient(
                    colors: [.black.opacity(0.0), .black.opacity(0.55)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 150)

                Image(systemName: item.category.symbol)
                    .font(.system(size: 60, weight: .bold))
                    .foregroundStyle(.white.opacity(0.18))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 20)

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: item.category.symbol)
                            .font(.system(size: 10, weight: .bold))
                        Text(item.category.label.uppercased())
                            .font(.system(size: 9, weight: .heavy))
                            .tracking(1.0)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(.ultraThinMaterial))

                    Text(item.merchantName)
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundStyle(.white)
                }
                .padding(14)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .clipped()

            VStack(alignment: .leading, spacing: 10) {
                Text(item.headline)
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundStyle(SourceColors.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                HStack(spacing: 8) {
                    Text(item.value)
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundStyle(SourceColors.success)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(SourceColors.success.opacity(0.14)))

                    SourceCountdownBadge(text: item.countdown)

                    Spacer(minLength: 0)
                }

                WhyMatchedView(reason: item.matchReason, matchScore: item.matchScore)

                HStack(spacing: 8) {
                    REAiLTrustBadge(score: item.trustScore)
                    Spacer(minLength: 0)
                    Text(item.price)
                        .font(.system(size: 12, weight: .heavy))
                        .foregroundStyle(SourceColors.textPrimary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
        .background(RoundedRectangle(cornerRadius: 22).fill(SourceColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(SourceColors.border, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.35), radius: 24, y: 12)
        .overlay(alignment: .topLeading) {
            if dragOffset.width < -40 {
                swipeLabel("PASS", color: SourceColors.danger)
                    .padding(18)
                    .opacity(min(1, Double(-dragOffset.width) / 160))
            }
        }
        .overlay(alignment: .topTrailing) {
            if dragOffset.width > 40 {
                swipeLabel("INTERESTED", color: SourceColors.success)
                    .padding(18)
                    .opacity(min(1, Double(dragOffset.width) / 160))
            }
        }
        .offset(x: dragOffset.width, y: dragOffset.height * 0.2)
        .rotationEffect(.degrees(Double(dragOffset.width) / 25))
    }

    private func swipeLabel(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 14, weight: .heavy))
            .tracking(1.0)
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(RoundedRectangle(cornerRadius: 8).strokeBorder(color, lineWidth: 2))
    }
}

// MARK: - Intent Packet

struct IntentPacketView: View {
    let item: SourceMatchItem

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(SourceColors.aiBlue)
                Text("INTENT PACKET")
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(1.2)
                    .foregroundStyle(SourceColors.aiBlue)
                Spacer()
                Text("Locked")
                    .font(.system(size: 10, weight: .heavy))
                    .foregroundStyle(SourceColors.success)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(SourceColors.success.opacity(0.15)))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)

            Divider().background(SourceColors.border)

            VStack(spacing: 0) {
                row("User intent", "Wants \(item.headline.lowercased())")
                row("Category", item.category.label)
                row("Provider", item.merchantName)
                row("Estimated budget", item.budget)
                row("Service area", item.serviceArea)
                row("Preferred time", item.preferredTime)
                row("Urgency", item.urgency)
                row("Match score", "\(item.matchScore)%")
                row("REAiL trust", "\(item.trustScore)")
                row("Provider next action", item.providerNextAction, isLast: true)
            }
        }
        .background(RoundedRectangle(cornerRadius: 16).fill(SourceColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(SourceColors.border, lineWidth: 1))
    }

    private func row(_ label: String, _ value: String, isLast: Bool = false) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                Text(label)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(SourceColors.textMuted)
                    .frame(width: 110, alignment: .leading)
                Text(value)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(SourceColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            if !isLast {
                Divider().background(SourceColors.border).padding(.leading, 14)
            }
        }
    }
}

// MARK: - Autopilot Status

struct AutopilotStatusView: View {
    struct StepInfo: Identifiable {
        let id = UUID()
        let label: String
    }
    let steps: [StepInfo]
    let activeIndex: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(index < activeIndex ? SourceColors.success : (index == activeIndex ? SourceColors.aiBlue : SourceColors.bgElevated))
                            .frame(width: 22, height: 22)
                        if index < activeIndex {
                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .heavy))
                                .foregroundStyle(.white)
                        } else if index == activeIndex {
                            Circle().fill(.white).frame(width: 8, height: 8)
                        } else {
                            Circle().fill(SourceColors.border).frame(width: 8, height: 8)
                        }
                    }
                    Text(step.label)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(index <= activeIndex ? SourceColors.textPrimary : SourceColors.textMuted)
                    Spacer(minLength: 0)
                }
            }
        }
    }
}

// MARK: - Mock Provider Notification

struct MockProviderNotificationView: View {
    let item: SourceMatchItem
    let onConfirm: () -> Void
    let onRequestInfo: () -> Void
    let onDecline: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(SourceColors.urgency)
                Text("MOCK PROVIDER NOTIFICATION")
                    .font(.system(size: 9, weight: .heavy))
                    .tracking(1.0)
                    .foregroundStyle(SourceColors.urgency)
                Spacer()
            }

            Text("Hot lead — \(item.matchScore)% match — expires in 15 min.")
                .font(.system(size: 14, weight: .heavy))
                .foregroundStyle(SourceColors.textPrimary)

            VStack(alignment: .leading, spacing: 6) {
                bullet("Wants: \(item.headline)")
                bullet("Budget: \(item.budget)")
                bullet("Preferred time: \(item.preferredTime)")
                bullet("Urgency: \(item.urgency)")
                bullet("Action: \(item.providerNextAction)")
            }

            HStack(spacing: 8) {
                Button(action: onDecline) {
                    Text("Decline")
                        .font(.system(size: 12, weight: .heavy))
                        .foregroundStyle(SourceColors.textPrimary)
                        .padding(.horizontal, 12).padding(.vertical, 9)
                        .background(Capsule().fill(SourceColors.bgElevated))
                        .overlay(Capsule().strokeBorder(SourceColors.border, lineWidth: 1))
                }
                Button(action: onRequestInfo) {
                    Text("Request Info")
                        .font(.system(size: 12, weight: .heavy))
                        .foregroundStyle(SourceColors.aiBlue)
                        .padding(.horizontal, 12).padding(.vertical, 9)
                        .background(Capsule().fill(SourceColors.aiBlueSoft))
                        .overlay(Capsule().strokeBorder(SourceColors.aiBlue.opacity(0.4), lineWidth: 1))
                }
                Spacer(minLength: 0)
                Button(action: onConfirm) {
                    Text("Confirm")
                        .font(.system(size: 12, weight: .heavy))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 14).padding(.vertical, 9)
                        .background(Capsule().fill(SourceColors.success))
                }
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(SourceColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(SourceColors.urgency.opacity(0.35), lineWidth: 1))
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Circle().fill(SourceColors.textMuted).frame(width: 4, height: 4).padding(.top, 7)
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(SourceColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - WINpay placeholder

struct WINpayPlaceholderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(SourceColors.aiBlue)
                Text("WINPAY — COMING NEXT")
                    .font(.system(size: 9, weight: .heavy))
                    .tracking(1.0)
                    .foregroundStyle(SourceColors.aiBlue)
                Spacer()
            }
            Text("Payment or deposit can be handled securely in the next version.")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(SourceColors.textSecondary)

            VStack(alignment: .leading, spacing: 3) {
                Text("Example future WINpay flow")
                    .font(.system(size: 10, weight: .heavy))
                    .foregroundStyle(SourceColors.textMuted)
                Text("User pays $10  •  Provider receives $7.50  •  WIN earns $2.50")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(SourceColors.textPrimary)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 10).fill(SourceColors.aiBlueSoft))

            Text("Demo only. No real payment processed.")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(SourceColors.textMuted)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(SourceColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(SourceColors.border, lineWidth: 1))
    }
}

// MARK: - Activity Row

struct MatchActivityRow: View {
    let event: SourceActivityEvent
    let item: SourceMatchItem

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(item.category.accent.opacity(0.25))
                    .frame(width: 40, height: 40)
                Image(systemName: item.category.symbol)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(item.category.accent)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(item.merchantName)
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundStyle(SourceColors.textPrimary)
                Text(item.headline)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(SourceColors.textSecondary)
                    .lineLimit(1)
                HStack(spacing: 6) {
                    Text(event.status.label.uppercased())
                        .font(.system(size: 8, weight: .heavy))
                        .tracking(0.8)
                        .foregroundStyle(event.status.color)
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(Capsule().fill(event.status.color.opacity(0.15)))
                    Text("\(item.matchScore)% match  •  Trust \(item.trustScore)")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(SourceColors.textMuted)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 14).fill(SourceColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(SourceColors.border, lineWidth: 1))
    }
}

// MARK: - Pill button

struct SourcePillButton: View {
    let title: String
    let systemImage: String?
    let style: Style
    let action: () -> Void

    enum Style { case primary, secondary, ghost, danger }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let s = systemImage {
                    Image(systemName: s).font(.system(size: 13, weight: .heavy))
                }
                Text(title).font(.system(size: 14, weight: .heavy))
            }
            .foregroundStyle(fg)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(bg)
            .overlay(Capsule().strokeBorder(border, lineWidth: 1))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var fg: Color {
        switch style {
        case .primary: return .black
        case .secondary: return SourceColors.textPrimary
        case .ghost: return SourceColors.textSecondary
        case .danger: return SourceColors.danger
        }
    }
    private var bg: some View {
        Group {
            switch style {
            case .primary: SourceColors.success
            case .secondary: SourceColors.bgElevated
            case .ghost: Color.clear
            case .danger: SourceColors.danger.opacity(0.14)
            }
        }
    }
    private var border: Color {
        switch style {
        case .primary: return SourceColors.success
        case .secondary: return SourceColors.border
        case .ghost: return SourceColors.border
        case .danger: return SourceColors.danger.opacity(0.4)
        }
    }
}
