import SwiftUI
import Combine

public class StoryStore: ObservableObject {
    
    var cancellable: AnyCancellable?
    @Published public var filter: StoryList = .top
    @Published public var stories: [Story] = []
    
    public init() {
        bind()
    }
    
    func bind() {
        $filter
            .receive(on: RunLoop.main)
            .sink(receiveValue: fetchStories)
    }
    
    func fetchStories(_ filter: StoryList) {
        self.stories = []
        cancellable?.cancel()
        cancellable = HNAPI.shared.fetch(list: filter)
            .receive(on: RunLoop.main)
            .assign(to: \.stories, on: self)
    }
}
