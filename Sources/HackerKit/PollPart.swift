import Foundation

public protocol PollPartProtocol {
    var poll: Int {get}
    var score: Int {get}
    var text: String {get}
}

public typealias PollPartType = ItemProtocol & PollPartProtocol & Decodable

public struct PollPart: PollPartType {
    public var by: String
    public var time: Date
    public var type: ItemType
    public var id: Int
    public var poll: Int
    public var score: Int
    public var text: String
}
