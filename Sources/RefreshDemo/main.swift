import Foundation
import RefreshCore

struct DemoFetcher: ConversationFetching {
    func fetchLatest(conversationID: String) async throws -> ConversationSnapshot {
        ConversationSnapshot(
            conversationID: conversationID,
            revision: 105,
            messages: [
                Message(id: "m1", text: "User message"),
                Message(id: "m2", text: "Completed assistant answer")
            ]
        )
    }
}

@main
struct Demo {
    static func main() async throws {
        var local = LocalConversationState(
            snapshot: ConversationSnapshot(
                conversationID: "conv-123",
                revision: 104,
                messages: [Message(id: "m1", text: "User message")]
            ),
            draft: "unsent draft — keep me",
            scrollAnchorMessageID: "m1",
            isLocallyStreaming: true
        )

        let refresher = ConversationRefresher(fetcher: DemoFetcher())
        let result = try await refresher.refresh(&local)

        print("result:", result)
        print("revision:", local.snapshot.revision)
        print("messages:", local.snapshot.messages.count)
        print("draft preserved:", local.draft)
        print("scroll preserved:", local.scrollAnchorMessageID ?? "nil")
        print("stream UI state preserved:", local.isLocallyStreaming)
    }
}
