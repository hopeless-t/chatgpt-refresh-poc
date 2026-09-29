import Testing
@testable import RefreshCore

private struct StaticFetcher: ConversationFetching {
    let snapshot: ConversationSnapshot

    func fetchLatest(conversationID: String) async throws -> ConversationSnapshot {
        snapshot
    }
}

@Test("newer server revision updates messages but preserves local-only UI state")
func updatesWithoutDestroyingLocalState() async throws {
    let localSnapshot = ConversationSnapshot(
        conversationID: "c1",
        revision: 10,
        messages: [Message(id: "m1", text: "hello")]
    )
    let serverSnapshot = ConversationSnapshot(
        conversationID: "c1",
        revision: 11,
        messages: [
            Message(id: "m1", text: "hello"),
            Message(id: "m2", text: "world")
        ]
    )

    var local = LocalConversationState(
        snapshot: localSnapshot,
        draft: "do not lose this",
        scrollAnchorMessageID: "m1",
        isLocallyStreaming: true
    )

    let refresher = ConversationRefresher(fetcher: StaticFetcher(snapshot: serverSnapshot))
    let result = try await refresher.refresh(&local)

    #expect(result == .updated(fromRevision: 10, toRevision: 11))
    #expect(local.snapshot == serverSnapshot)
    #expect(local.draft == "do not lose this")
    #expect(local.scrollAnchorMessageID == "m1")
    #expect(local.isLocallyStreaming == true)
}

@Test("same or older server revision is a no-op")
func staleSnapshotIsNoOp() async throws {
    let localSnapshot = ConversationSnapshot(
        conversationID: "c1",
        revision: 10,
        messages: [Message(id: "m1", text: "new")]
    )
    let staleSnapshot = ConversationSnapshot(
        conversationID: "c1",
        revision: 9,
        messages: [Message(id: "m1", text: "old")]
    )

    var local = LocalConversationState(snapshot: localSnapshot, draft: "draft")
    let refresher = ConversationRefresher(fetcher: StaticFetcher(snapshot: staleSnapshot))
    let result = try await refresher.refresh(&local)

    #expect(result == .unchanged)
    #expect(local.snapshot == localSnapshot)
    #expect(local.draft == "draft")
}

@Test("snapshot from another conversation is ignored")
func wrongConversationIsIgnored() async throws {
    var local = LocalConversationState(
        snapshot: ConversationSnapshot(conversationID: "c1", revision: 1, messages: [])
    )
    let foreignSnapshot = ConversationSnapshot(
        conversationID: "c2",
        revision: 99,
        messages: [Message(id: "oops", text: "wrong conversation")]
    )

    let refresher = ConversationRefresher(fetcher: StaticFetcher(snapshot: foreignSnapshot))
    let result = try await refresher.refresh(&local)

    #expect(result == .unchanged)
    #expect(local.snapshot.conversationID == "c1")
    #expect(local.snapshot.revision == 1)
}
