import Foundation

public struct Constants {
    public static let baseURL = URL(string: "https://hacker-news.firebaseio.com/v0")!
    
    public static func itemURL(for id: Int) -> URL {
        baseURL
            .appendingPathComponent("item")
            .appendingPathComponent(String(id), isDirectory: false)
            .appendingPathExtension("json")
    }
}
