import Foundation

public protocol UserProtocol {
    var id: String {get}
    var about: String? {get}
    var created: Date {get}
    var karma: Int {get}
    var submitted: [Int] {get}
}

public typealias UserType = UserProtocol & Decodable

public struct User: UserType {
    public var id: String
    public var about: String?
    public var created: Date
    public var karma: Int
    public var submitted: [Int]
}
