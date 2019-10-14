import SwiftUI
import Combine

public class CommentStore: ObservableObject {
    public static let shared = CommentStore()
    
    public var cancellable: AnyCancellable?
    @Published public var comments: [Comment] = []
    
    public init() {
    }
    
    var lastStory: Story?
    
    public func fetchComments(ids: [Int]?) {
        cancellable?.cancel()
        
        guard let comments = ids, !comments.isEmpty else {
            return
        }
        
        cancellable = HNAPI.shared.fetch(comments: comments)
            .receive(on: RunLoop.main)
            .assign(to: \.comments, on: self)
    }
    
    public func fetchComments(_ story: Story?) {
        cancellable?.cancel()
        
        guard let story = story, let comments = story.kids, !comments.isEmpty else {
            return
        }
        
        cancellable = HNAPI.shared.fetch(comments: comments)
            .receive(on: RunLoop.main)
            .assign(to: \.comments, on: self)
    }
}
