import Foundation

public protocol PollProtocol {
    var title: String {get}
    var text: String? {get}
    var parts: [Int] {get}
    var kids: [Int] {get}
}

public typealias PollType = ItemProtocol & PollProtocol & Decodable

public struct Poll: PollType {
    public var by: String
    public var time: Date
    public var type: ItemType
    public var id: Int
    public var title: String
    public var text: String?
    public var parts: [Int]
    public var kids: [Int]
}
