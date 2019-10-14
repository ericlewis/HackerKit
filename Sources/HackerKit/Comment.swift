import Foundation

public protocol CommentProtocol {
    var text: String {get}
    var parent: Int {get}
    var kids: [Int]? {get}
}

public typealias CommentType = ItemProtocol & CommentProtocol & Decodable

public struct Comment: CommentType {
    public var by: String
    public var time: Date
    public var type: ItemType
    public var id: Int
    public var text: String
    public var parent: Int
    public var kids: [Int]?
}
