import Foundation

public protocol ConversationFetching: Sendable {
    func fetchLatest(conversationID: String) async throws -> ConversationSnapshot
}

public enum RefreshResult: Equatable, Sendable {
    case unchanged
    case updated(fromRevision: Int, toRevision: Int)
}

public struct ConversationRefresher: Sendable {
    private let fetcher: any ConversationFetching

    public init(fetcher: any ConversationFetching) {
        self.fetcher = fetcher
    }

    /// Read-only synchronization of the currently open conversation.
    ///
    /// Guarantees:
    /// - never sends a message
    /// - never regenerates a response
    /// - never creates a conversation
    /// - preserves draft, scroll anchor, and local streaming UI state
    /// - ignores server snapshots that are not newer than local state
    public func refresh(_ local: inout LocalConversationState) async throws -> RefreshResult {
        let oldRevision = local.snapshot.revision
        let latest = try await fetcher.fetchLatest(conversationID: local.snapshot.conversationID)

        guard latest.conversationID == local.snapshot.conversationID else {
            return .unchanged
        }

        guard latest.revision > oldRevision else {
            return .unchanged
        }

        // Replace canonical server-backed conversation state only.
        // Local-only UI state remains untouched by design.
        local.snapshot = latest

        return .updated(fromRevision: oldRevision, toRevision: latest.revision)
    }
}
