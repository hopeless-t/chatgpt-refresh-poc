#if canImport(SwiftUI)
import SwiftUI
import RefreshCore

/// Illustrative UI only: production code would wire this into the app's
/// existing conversation store and server fetch path.
struct RefreshConversationButton: View {
    let refresh: () async -> Void
    @State private var isRefreshing = false

    var body: some View {
        Button {
            guard !isRefreshing else { return }
            isRefreshing = true
            Task {
                await refresh()
                isRefreshing = false
            }
        } label: {
            Label(
                isRefreshing ? "Refreshing…" : "Refresh conversation",
                systemImage: "arrow.clockwise"
            )
        }
        .disabled(isRefreshing)
        .accessibilityHint("Fetches newer messages without sending or regenerating anything")
    }
}
#endif
