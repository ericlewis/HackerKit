import Foundation 

public protocol StoryProtocol {
    var title: String {get}
    var score: Int {get}
    var text: String? {get}
    var url: URL? {get}
    
    var descendants: Int {get}
    var kids: [Int]? {get}
}

public typealias StoryType = ItemProtocol & StoryProtocol & Decodable

public struct Story: StoryType {
    public var by: String
    public var time: Date
    public var type: ItemType
    public var id: Int
    public var title: String
    public var score: Int
    public var text: String?
    public var url: URL?
    public var descendants: Int
    public var kids: [Int]?
}
