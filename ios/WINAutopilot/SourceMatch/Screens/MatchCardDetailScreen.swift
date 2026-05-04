import SwiftUI
import UIKit

struct MatchCardDetailScreen: View {
    let item: SourceMatchItem
    var onInterested: (SourceMatchItem) -> Void
    var onPass: (SourceMatchItem) -> Void
    var onSave: (SourceMatchItem) -> Void
    var onClose: () -> Void

    var body: some View {
        ZStack {
            SourceColors.bg.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // Hero block
                    ZStack(alignment: .bottomLeading) {
                        LinearGradient(
                            colors: [item.category.accent.opacity(0.85), item.category.accent.opacity(0.40)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 200)

                        Image(systemName: item.category.symbol)
                            .font(.system(size: 90, weight: .bold))
                            .foregroundStyle(.white.opacity(0.18))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 24)
                            .padding(.top, 30)

                        LinearGradient(colors: [.black.opacity(0), .black.opacity(0.6)], startPoint: .top, endPoint: .bottom)
                            .frame(height: 200)

                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 6) {
                                Image(systemName: item.category.symbol)
                                    .font(.system(size: 11, weight: .bold))
                                Text(item.category.label.uppercased())
                                    .font(.system(size: 10, weight: .heavy))
                                    .tracking(1.0)
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10).padding(.vertical, 5)
                            .background(Capsule().fill(.ultraThinMaterial))

                            Text(item.merchantName)
                                .font(.system(size: 15, weight: .heavy))
                                .foregroundStyle(.white)

                            Text(item.headline)
                                .font(.system(size: 26, weight: .heavy))
                                .foregroundStyle(.white)
                                .lineLimit(2)

                            HStack(spacing: 8) {
                                Text("\(item.matchScore)% match")
                                    .font(.system(size: 11, weight: .heavy))
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 8).padding(.vertical, 4)
                                    .background(Capsule().fill(SourceColors.success))
                                SourceCountdownBadge(text: item.countdown)
                            }
                        }
                        .padding(20)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal, 16)

                    // Trust
                    section(title: "REAiL TRUST", iconColor: SourceColors.trustGold, icon: "checkmark.seal.fill") {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 10) {
                                REAiLTrustBadge(score: item.trustScore)
                                Spacer()
                                Text(item.value)
                                    .font(.system(size: 12, weight: .heavy))
                                    .foregroundStyle(SourceColors.success)
                                    .padding(.horizontal, 8).padding(.vertical, 4)
                                    .background(Capsule().fill(SourceColors.success.opacity(0.14)))
                            }
                            TrustChecklistView(checks: item.trustChecks)
                            Text("REAiL trust data is mocked for this MVP. Real verification connects later.")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(SourceColors.textMuted)
                        }
                    }

                    // Why this matched
                    WhyMatchedView(reason: item.matchReason, matchScore: item.matchScore)
                        .padding(.horizontal, 16)

                    // Terms
                    section(title: "TERMS", iconColor: SourceColors.aiBlue, icon: "doc.text.fill") {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(item.terms, id: \.self) { term in
                                HStack(alignment: .top, spacing: 8) {
                                    Circle().fill(SourceColors.textMuted).frame(width: 4, height: 4).padding(.top, 7)
                                    Text(term)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundStyle(SourceColors.textSecondary)
                                }
                            }
                        }
                    }

                    // Autopilot preview
                    section(title: "WHAT SOURCE WILL DO", iconColor: SourceColors.aiBlue, icon: "bolt.fill") {
                        AutopilotStatusView(
                            steps: [
                                .init(label: "Capture your intent"),
                                .init(label: "Prepare Intent Packet"),
                                .init(label: "Attach REAiL trust checks"),
                                .init(label: "Send to provider"),
                                .init(label: "Ask provider to confirm"),
                            ],
                            activeIndex: 0
                        )
                    }

                    Spacer(minLength: 80)
                }
                .padding(.bottom, 100)
            }

            VStack {
                HStack {
                    Button(action: onClose) {
                        Image(systemName: "chevron.down")
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

                VStack(spacing: 10) {
                    Button {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        onInterested(item)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "hand.raised.fill")
                            Text("I'm Interested")
                        }
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Capsule().fill(SourceColors.success))
                    }
                    HStack(spacing: 10) {
                        SourcePillButton(title: "Pass", systemImage: "xmark", style: .danger) {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            onPass(item)
                        }
                        SourcePillButton(title: "Save", systemImage: "bookmark.fill", style: .secondary) {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            onSave(item)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 18)
                .background(
                    LinearGradient(colors: [SourceColors.bg.opacity(0), SourceColors.bg], startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .preferredColorScheme(.dark)
    }

    private func section<Content: View>(title: String, iconColor: Color, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(iconColor)
                Text(title)
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(1.2)
                    .foregroundStyle(iconColor)
            }
            content()
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(SourceColors.bgCard))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(SourceColors.border, lineWidth: 1))
        .padding(.horizontal, 16)
    }
}
