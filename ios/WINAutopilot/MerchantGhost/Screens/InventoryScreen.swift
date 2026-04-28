import SwiftUI

struct InventoryScreen: View {
    @Bindable var store: GhostStore
    let onContinue: () -> Void

    @State private var newName: String = ""
    @State private var newType: InventoryType = .bestSeller

    var body: some View {
        ScrollView {
            VStack(spacing: ConsumerSpacing.md) {
                GhostHeader(
                    step: 1, total: 5,
                    title: "Pick what WIN can use",
                    subtitle: "Tag products so AI can build smart offers."
                )

                GhostCard {
                    Text("QUICK ADD")
                        .font(.system(size: 11, weight: .heavy))
                        .tracking(0.6)
                        .foregroundStyle(ConsumerColors.aiBlue)

                    let suggestions = store.quickAddSuggestions(for: store.merchant.category)
                    FlowLayout(spacing: 8) {
                        ForEach(suggestions, id: \.0) { item in
                            let already = store.inventory.contains { $0.productName == item.0 }
                            Button {
                                if !already {
                                    store.addInventoryItem(MerchantInventoryItem(productName: item.0, type: item.1))
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: already ? "checkmark.circle.fill" : "plus.circle.fill")
                                        .foregroundStyle(already ? ConsumerColors.green : ConsumerColors.aiBlue)
                                    Text(item.0)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(ConsumerColors.textDark)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(already ? ConsumerColors.greenSoft : ConsumerColors.aiBlueSoft)
                                .clipShape(Capsule())
                            }
                            .disabled(already)
                        }
                    }
                }
                .padding(.horizontal, ConsumerSpacing.screen)

                GhostCard {
                    Text("ADD CUSTOM PRODUCT")
                        .font(.system(size: 11, weight: .heavy))
                        .tracking(0.6)
                        .foregroundStyle(ConsumerColors.textMid)

                    GhostField(label: "PRODUCT NAME", text: $newName, placeholder: "e.g. Fish Taco")

                    VStack(alignment: .leading, spacing: 6) {
                        Text("TYPE")
                            .font(.system(size: 11, weight: .heavy))
                            .tracking(0.6)
                            .foregroundStyle(ConsumerColors.textMid)
                        FlowLayout(spacing: 8) {
                            ForEach(InventoryType.allCases) { t in
                                GhostTagChip(label: t.label, selected: newType == t) { newType = t }
                            }
                        }
                        Text(newType.hint)
                            .font(.system(size: 12))
                            .foregroundStyle(ConsumerColors.textMid)
                    }

                    Button {
                        let trimmed = newName.trimmingCharacters(in: .whitespaces)
                        guard !trimmed.isEmpty else { return }
                        store.addInventoryItem(MerchantInventoryItem(productName: trimmed, type: newType))
                        newName = ""
                    } label: {
                        Text("Add Product")
                            .font(.system(size: 14, weight: .heavy))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(ConsumerColors.greenNeon)
                            .clipShape(.rect(cornerRadius: ConsumerSpacing.radiusBtn))
                    }
                }
                .padding(.horizontal, ConsumerSpacing.screen)

                if !store.inventory.isEmpty {
                    GhostCard {
                        Text("YOUR INVENTORY")
                            .font(.system(size: 11, weight: .heavy))
                            .tracking(0.6)
                            .foregroundStyle(ConsumerColors.textMid)

                        ForEach(store.inventory) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.productName)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(ConsumerColors.textDark)
                                    Text(item.type.label)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundStyle(ConsumerColors.aiBlue)
                                }
                                Spacer()
                                Button {
                                    store.removeInventoryItem(item.id)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(ConsumerColors.red)
                                }
                            }
                            .padding(.vertical, 6)
                            if item.id != store.inventory.last?.id {
                                Divider().background(ConsumerColors.borderLight)
                            }
                        }
                    }
                    .padding(.horizontal, ConsumerSpacing.screen)
                }

                Spacer(minLength: 12)

                GhostPrimaryButton(
                    title: "Continue to Slow Hours",
                    enabled: !store.inventory.isEmpty
                ) {
                    onContinue()
                }

                Spacer(minLength: 24)
            }
        }
        .background(ConsumerColors.bgWarm)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Simple flow layout for chips
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > maxWidth {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: maxWidth == .infinity ? x : maxWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x: CGFloat = bounds.minX
        var y: CGFloat = bounds.minY
        var rowHeight: CGFloat = 0
        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            sub.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
