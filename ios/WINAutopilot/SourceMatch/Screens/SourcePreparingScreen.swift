import SwiftUI
import UIKit

struct SourcePreparingScreen: View {
    @Bindable var store: SourceMatchStore
    let item: SourceMatchItem
    let event: SourceActivityEvent
    var onClose: () -> Void

    @State private var activeIndex: Int = 0
    @State private var showPacket: Bool = false
    @State private var providerStatus: SourceActivityStatus = .sourcePreparing
    @State private var providerMessage: String?

    private let preparingSteps: [AutopilotStatusView.StepInfo] = [
        .init(label: "Intent captured"),
        .init(label: "Match reason saved"),
        .init(label: "REAiL trust checks attached"),
        .init(label: "Terms locked"),
        .init(label: "Intent Packet created"),
        .init(label: "Routing to provider"),
    ]

    var body: some View {
        ZStack {
            SourceColors.bg.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    headerCard

                    sectionCard(title: "AUTOPILOT", icon: "bolt.fill", color: SourceColors.aiBlue) {
                        AutopilotStatusView(steps: preparingSteps, activeIndex: activeIndex)
                    }

                    if showPacket {
                        Text("Provider has 15 minutes to confirm.")
                            .font(.system(size: 13, weight: .heavy))
                            .foregroundStyle(SourceColors.urgency)
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Capsule().fill(SourceColors.urgency.opacity(0.14)))
                            .overlay(Capsule().strokeBorder(SourceColors.urgency.opacity(0.4), lineWidth: 1))
                            .padding(.horizontal, 16)

                        IntentPacketView(item: item)
                            .padding(.horizontal, 16)

                        MockProviderNotificationView(
                            item: item,
                            onConfirm: { simulateProviderResponse(.confirmed, message: "Confirmed. SOURCE prepared your next step.") },
                            onRequestInfo: { simulateProviderResponse(.providerReviewing, message: "Provider asked for more info.") },
                            onDecline: { simulateProviderResponse(.expired, message: "Provider declined this match.") }
                        )
                        .padding(.horizontal, 16)

                        providerStatusCard

                        if providerStatus == .confirmed {
                            sectionCard(title: "NEXT STEP", icon: "arrow.right.circle.fill", color: SourceColors.success) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(nextStepHeadline)
                                        .font(.system(size: 14, weight: .heavy))
                                        .foregroundStyle(SourceColors.textPrimary)
                                    Text(item.autopilotNextStep)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(SourceColors.textSecondary)
                                }
                            }
                        }

                        WINpayPlaceholderView()
                            .padding(.horizontal, 16)

                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            simulateProviderResponse(.confirmed, message: "Confirmed. SOURCE prepared your next step.")
                        } label: {
                            Text("Simulate Provider Confirmed")
                                .font(.system(size: 13, weight: .heavy))
                                .foregroundStyle(SourceColors.aiBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Capsule().fill(SourceColors.aiBlueSoft))
                                .overlay(Capsule().strokeBorder(SourceColors.aiBlue.opacity(0.4), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 16)

                        Spacer(minLength: 30)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 30)
            }

            VStack {
                HStack {
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .heavy))
                            .foregroundStyle(SourceColors.textPrimary)
                            .padding(10)
                            .background(Circle().fill(SourceColors.bgElevated))
                            .overlay(Circle().strokeBorder(SourceColors.border, lineWidth: 1))
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        .onAppear { runChecklist() }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundStyle(SourceColors.aiBlue)
                Text("SOURCE")
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(1.2)
                    .foregroundStyle(SourceColors.aiBlue)
                Spacer()
            }
            Text("SOURCE is preparing this for you.")
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(SourceColors.textPrimary)
            Text("REAiL is locking the terms and preparing your Intent Packet.")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(SourceColors.textSecondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(colors: [SourceColors.aiBlue.opacity(0.18), SourceColors.bgCard],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(SourceColors.aiBlue.opacity(0.3), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal, 16)
        .padding(.top, 36)
    }

    private var providerStatusCard: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(providerStatus.color)
                .frame(width: 10, height: 10)
            VStack(alignment: .leading, spacing: 2) {
                Text(providerStatus.label.uppercased())
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(1.0)
                    .foregroundStyle(providerStatus.color)
                if let msg = providerMessage {
                    Text(msg)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(SourceColors.textPrimary)
                }
            }
            Spacer()
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 14).fill(SourceColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(providerStatus.color.opacity(0.35), lineWidth: 1))
        .padding(.horizontal, 16)
    }

    private var nextStepHeadline: String {
        switch item.category {
        case .food, .coffee: return "Pickup instructions ready."
        case .beauty: return "Slot confirmation ready."
        case .homeService: return "Arrival window request ready."
        }
    }

    private func sectionCard<Content: View>(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(color)
                Text(title)
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(1.2)
                    .foregroundStyle(color)
            }
            content()
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(SourceColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(SourceColors.border, lineWidth: 1))
        .padding(.horizontal, 16)
    }

    private func runChecklist() {
        activeIndex = 0
        for i in 0..<preparingSteps.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.55) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    activeIndex = i + 1
                }
                UISelectionFeedbackGenerator().selectionChanged()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(preparingSteps.count) * 0.55 + 0.2) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                showPacket = true
                providerStatus = .sentToProvider
                providerMessage = "Sent to provider — awaiting response."
            }
            store.updateStatus(eventId: event.id, status: .sentToProvider)
        }
    }

    private func simulateProviderResponse(_ status: SourceActivityStatus, message: String) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            providerStatus = status
            providerMessage = message
        }
        store.updateStatus(eventId: event.id, status: status)
    }
}
