import SwiftUI

struct MatchActivityScreen: View {
    @Bindable var store: SourceMatchStore
    var onClose: () -> Void

    @State private var filter: SourceActivityType? = nil

    private var filteredEvents: [SourceActivityEvent] {
        guard let filter else { return store.activity }
        return store.activity.filter { $0.type == filter }
    }

    var body: some View {
        ZStack {
            SourceColors.bg.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 14) {
                header
                filterRow

                if filteredEvents.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(filteredEvents) { event in
                                if let item = store.item(for: event) {
                                    MatchActivityRow(event: event, item: item)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
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
            VStack(spacing: 2) {
                Text("MATCH ACTIVITY")
                    .font(.system(size: 11, weight: .heavy))
                    .tracking(1.4)
                    .foregroundStyle(SourceColors.textPrimary)
                Text("Saved, interested, and passed.")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(SourceColors.textMuted)
            }
            Spacer()
            Spacer().frame(width: 36)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var filterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip(title: "All", isOn: filter == nil) { filter = nil }
                chip(title: "Interested", isOn: filter == .interested) { filter = .interested }
                chip(title: "Saved", isOn: filter == .saved) { filter = .saved }
                chip(title: "Passed", isOn: filter == .passed) { filter = .passed }
            }
            .padding(.horizontal, 16)
        }
    }

    private func chip(title: String, isOn: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .heavy))
                .foregroundStyle(isOn ? .black : SourceColors.textPrimary)
                .padding(.horizontal, 12).padding(.vertical, 7)
                .background(Capsule().fill(isOn ? SourceColors.success : SourceColors.bgElevated))
                .overlay(Capsule().strokeBorder(isOn ? SourceColors.success : SourceColors.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Spacer()
            Image(systemName: "tray")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(SourceColors.aiBlue)
            Text("No activity yet.")
                .font(.system(size: 15, weight: .heavy))
                .foregroundStyle(SourceColors.textPrimary)
            Text("Swipe right on a match to let SOURCE prepare the next step.")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(SourceColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
