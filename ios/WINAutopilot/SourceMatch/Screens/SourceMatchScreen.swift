import SwiftUI
import UIKit

struct SourceMatchScreen: View {
    @Bindable var store: SourceMatchStore
    var onClose: () -> Void
    var onOpenActivity: () -> Void
    var onInterested: (SourceMatchItem, SourceActivityEvent) -> Void
    var onOpenDetail: (SourceMatchItem) -> Void

    @State private var dragOffset: CGSize = .zero
    @State private var toast: String?

    var body: some View {
        ZStack {
            SourceColors.bg.ignoresSafeArea()
            backgroundOrbs

            VStack(spacing: 16) {
                header

                if let item = store.currentItem {
                    SourceMatchCard(item: item, dragOffset: dragOffset)
                        .id(item.id)
                        .padding(.horizontal, 16)
                        .gesture(
                            DragGesture()
                                .onChanged { value in dragOffset = value.translation }
                                .onEnded { value in handleDragEnd(value, item: item) }
                        )
                        .onTapGesture { onOpenDetail(item) }
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.94).combined(with: .opacity),
                            removal: .opacity
                        ))

                    actionRow(for: item)
                        .padding(.horizontal, 16)

                    Text("Tap card for details")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(SourceColors.textMuted)
                } else {
                    emptyState
                }

                Spacer(minLength: 0)
            }
            .padding(.top, 8)
            .padding(.bottom, 16)
            .animation(.spring(response: 0.45, dampingFraction: 0.85), value: store.currentItem?.id)

            if let msg = toast {
                VStack { Spacer()
                    Text(msg)
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16).padding(.vertical, 10)
                        .background(Capsule().fill(SourceColors.bgElevated))
                        .overlay(Capsule().strokeBorder(SourceColors.border, lineWidth: 1))
                        .padding(.bottom, 28)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .allowsHitTesting(false)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        HStack(alignment: .center) {
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundStyle(SourceColors.textPrimary)
                    .padding(10)
                    .background(Circle().fill(SourceColors.bgElevated))
                    .overlay(Circle().strokeBorder(SourceColors.border, lineWidth: 1))
            }

            Spacer()

            VStack(spacing: 2) {
                HStack(spacing: 6) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 11, weight: .heavy))
                        .foregroundStyle(SourceColors.aiBlue)
                    Text("WIN SOURCE")
                        .font(.system(size: 14, weight: .heavy))
                        .tracking(1.5)
                        .foregroundStyle(SourceColors.textPrimary)
                }
                Text("Real-life matches, ready to act.")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(SourceColors.textMuted)
            }

            Spacer()

            Button(action: onOpenActivity) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "tray.full.fill")
                        .font(.system(size: 14, weight: .heavy))
                        .foregroundStyle(SourceColors.textPrimary)
                        .padding(10)
                        .background(Circle().fill(SourceColors.bgElevated))
                        .overlay(Circle().strokeBorder(SourceColors.border, lineWidth: 1))
                    if !store.activity.isEmpty {
                        Circle()
                            .fill(SourceColors.success)
                            .frame(width: 8, height: 8)
                            .padding(.top, 4).padding(.trailing, 4)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private func actionRow(for item: SourceMatchItem) -> some View {
        HStack(spacing: 12) {
            roundButton(icon: "xmark", color: SourceColors.danger, size: 56) {
                handlePass(item)
            }
            roundButton(icon: "bookmark.fill", color: SourceColors.aiBlue, size: 50) {
                handleSave(item)
            }
            interestedButton(item: item)
        }
    }

    private func roundButton(icon: String, color: Color, size: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.36, weight: .heavy))
                .foregroundStyle(color)
                .frame(width: size, height: size)
                .background(Circle().fill(SourceColors.bgCard))
                .overlay(Circle().strokeBorder(color.opacity(0.4), lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }

    private func interestedButton(item: SourceMatchItem) -> some View {
        Button {
            handleInterested(item)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 14, weight: .heavy))
                Text("I'm Interested")
                    .font(.system(size: 15, weight: .heavy))
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(colors: [SourceColors.success, SourceColors.success.opacity(0.85)],
                               startPoint: .top, endPoint: .bottom)
            )
            .clipShape(Capsule())
            .shadow(color: SourceColors.success.opacity(0.5), radius: 16, y: 6)
        }
        .buttonStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle().fill(SourceColors.aiBlueSoft).frame(width: 90, height: 90)
                Image(systemName: "sparkle.magnifyingglass")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(SourceColors.aiBlue)
            }
            Text("No more matches right now.")
                .font(.system(size: 17, weight: .heavy))
                .foregroundStyle(SourceColors.textPrimary)
            Text("SOURCE is watching for the next real opportunity.")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(SourceColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                    store.currentIndex = 0
                }
            } label: {
                Text("Reset demo matches")
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 18).padding(.vertical, 11)
                    .background(Capsule().fill(SourceColors.success))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 60)
    }

    private var backgroundOrbs: some View {
        ZStack {
            Circle()
                .fill(SourceColors.aiBlue.opacity(0.18))
                .frame(width: 280, height: 280)
                .blur(radius: 60)
                .offset(x: -120, y: -260)
            Circle()
                .fill(SourceColors.trustGold.opacity(0.10))
                .frame(width: 240, height: 240)
                .blur(radius: 70)
                .offset(x: 140, y: 280)
        }
        .allowsHitTesting(false)
    }

    private func handleDragEnd(_ value: DragGesture.Value, item: SourceMatchItem) {
        if value.translation.width > 110 {
            withAnimation(.easeOut(duration: 0.2)) {
                dragOffset = CGSize(width: 600, height: value.translation.height)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                handleInterested(item)
                dragOffset = .zero
            }
        } else if value.translation.width < -110 {
            withAnimation(.easeOut(duration: 0.2)) {
                dragOffset = CGSize(width: -600, height: value.translation.height)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                handlePass(item)
                dragOffset = .zero
            }
        } else if value.translation.height < -100 {
            handleSave(item)
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { dragOffset = .zero }
        } else {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { dragOffset = .zero }
        }
    }

    private func handleInterested(_ item: SourceMatchItem) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        let event = store.recordInterested(item)
        store.advance()
        onInterested(item, event)
    }

    private func handlePass(_ item: SourceMatchItem) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        store.recordPassed(item)
        store.advance()
    }

    private func handleSave(_ item: SourceMatchItem) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        store.recordSaved(item)
        showToast("Saved. SOURCE can prepare this when you're ready.")
    }

    private func showToast(_ message: String) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) { toast = message }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if toast == message {
                withAnimation(.easeIn(duration: 0.25)) { toast = nil }
            }
        }
    }
}
