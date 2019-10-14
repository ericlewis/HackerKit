public enum ItemType: String, Decodable {
    case 
    story, 
    job, 
    comment, 
    poll, 
    pollopt = "Poll Option"
}

extension ItemType {
    public var title: String {
        rawValue.localizedCapitalized
    }
}
