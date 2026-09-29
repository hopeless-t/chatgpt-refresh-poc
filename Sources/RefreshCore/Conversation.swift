import Foundation

public struct Message: Identifiable, Equatable, Sendable {
    public let id: String
    public var text: String

    public init(id: String, text: String) {
        self.id = id
        self.text = text
    }
}

public struct ConversationSnapshot: Equatable, Sendable {
    public let conversationID: String
    public let revision: Int
    public let messages: [Message]

    public init(conversationID: String, revision: Int, messages: [Message]) {
        self.conversationID = conversationID
        self.revision = revision
        self.messages = messages
    }
}

public struct LocalConversationState: Equatable, Sendable {
    public var snapshot: ConversationSnapshot
    public var draft: String
    public var scrollAnchorMessageID: String?
    public var isLocallyStreaming: Bool

    public init(
        snapshot: ConversationSnapshot,
        draft: String = "",
        scrollAnchorMessageID: String? = nil,
        isLocallyStreaming: Bool = false
    ) {
        self.snapshot = snapshot
        self.draft = draft
        self.scrollAnchorMessageID = scrollAnchorMessageID
        self.isLocallyStreaming = isLocallyStreaming
    }
}
