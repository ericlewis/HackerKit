import Foundation

public protocol ItemProtocol: Identifiable {
    var id: Int {get}
    var by: String {get}
    var time: Date {get}
    var type: ItemType {get}
}
