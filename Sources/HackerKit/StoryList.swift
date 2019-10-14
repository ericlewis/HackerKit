public enum StoryList: String, CaseIterable, Identifiable {
    case 
    new, 
    top, 
    best, 
    ask, 
    show, 
    job
    
    public var id: String {
        rawValue
    }
}

extension StoryList {
    public var title: String {
        rawValue.localizedCapitalized
    }
}

extension StoryList {
    public var path: String {
        rawValue + "stories"
    }
}
