import SwiftUI

struct SourceMatchFlow: View {
    var onClose: () -> Void

    @State private var store = SourceMatchStore()
    @State private var detailItem: SourceMatchItem?
    @State private var preparingPair: PreparingPair?
    @State private var showActivity: Bool = false

    private struct PreparingPair: Identifiable {
        let id: String
        let item: SourceMatchItem
        let event: SourceActivityEvent
    }

    var body: some View {
        SourceMatchScreen(
            store: store,
            onClose: onClose,
            onOpenActivity: { showActivity = true },
            onInterested: { item, event in
                preparingPair = PreparingPair(id: event.id, item: item, event: event)
            },
            onOpenDetail: { item in
                detailItem = item
            }
        )
        .sheet(item: $detailItem) { item in
            MatchCardDetailScreen(
                item: item,
                onInterested: { selected in
                    detailItem = nil
                    let event = store.recordInterested(selected)
                    if store.currentItem?.id == selected.id { store.advance() }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        preparingPair = PreparingPair(id: event.id, item: selected, event: event)
                    }
                },
                onPass: { selected in
                    detailItem = nil
                    store.recordPassed(selected)
                    if store.currentItem?.id == selected.id { store.advance() }
                },
                onSave: { selected in
                    detailItem = nil
                    store.recordSaved(selected)
                },
                onClose: { detailItem = nil }
            )
            .presentationDragIndicator(.visible)
        }
        .fullScreenCover(item: $preparingPair) { pair in
            SourcePreparingScreen(
                store: store,
                item: pair.item,
                event: pair.event,
                onClose: { preparingPair = nil }
            )
        }
        .sheet(isPresented: $showActivity) {
            MatchActivityScreen(store: store, onClose: { showActivity = false })
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    SourceMatchFlow(onClose: {})
}
