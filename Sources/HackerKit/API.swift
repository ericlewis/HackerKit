import Combine
import Foundation

public class HNAPI {
    public static let networkActivity = PassthroughSubject<Bool, Never>()
    public static let shared = HNAPI()
    
    var cancellable: AnyCancellable?
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    
    let commentQueue = DispatchQueue(label: "Comments", attributes: .concurrent)
    
    let storyQueue = DispatchQueue(label: "Stories", attributes: .concurrent)
    
    let userQueue = DispatchQueue(label: "Users", attributes: .concurrent)
    
    public func fetch(list: StoryList) -> AnyPublisher<[Story], Never> {
        URLSession.shared.dataTaskPublisher(for: 
            Constants.baseURL
                .appendingPathComponent(list.path)
                .appendingPathExtension("json")
        )
            .handleEvents(receiveSubscription: { _ in
                HNAPI.networkActivity.send(true)
            },receiveOutput: nil, receiveCompletion: { _ in
                HNAPI.networkActivity.send(false)
            }, receiveCancel: {
                HNAPI.networkActivity.send(false)
            }, receiveRequest: nil)
        .subscribe(on: storyQueue)
            .map { $0.data }
            .decode(type: [Int].self, decoder: decoder)
            .catch { _ in
                Just([])
        }
        .map {
            Array($0.prefix(60))
        }
        .flatMap(fetchParallelItems)
        .eraseToAnyPublisher()
    }
    
    public func fetch(user: String) -> AnyPublisher<User?, Never> {
        URLSession.shared.dataTaskPublisher(for: 
            Constants.baseURL
            .appendingPathComponent("user")
            .appendingPathComponent(user)
            .appendingPathExtension("json")
        )
        .subscribe(on: userQueue)
        .map { $0.data }
        .decode(type: User?.self, decoder: decoder)
        .catch { _ in
            Just<User?>(nil)
        }
        .eraseToAnyPublisher()
    }
    
    public func fetch(comments: [Int]) -> AnyPublisher<[Comment], Never> {
        fetchParallelItems(comments)
        .subscribe(on: commentQueue)
        .eraseToAnyPublisher()
    }
    
    func fetchParallelItems<Item: Decodable>(_ ids: [Int]) -> AnyPublisher<[Item], Never> {
        ids.publisher
            .collect(4)
            .flatMap(fetchItems)
            .scan([], +)
            .eraseToAnyPublisher()
    }
    
    func fetchItems<Item: Decodable>(_ ids: [Int]) -> AnyPublisher<[Item], Never> {
        switch ids.count {
        case 1:
            return fetchItem(ids.first!)
                .collect()
                .eraseToAnyPublisher()
        case 2:
            return Publishers.Zip(fetchItem(ids.first!), fetchItem(ids.last!))
                .map {
                    [$0.0, $0.1]
            }
            .eraseToAnyPublisher()
        case 3:
            return Publishers.Zip3(fetchItem(ids[0]), fetchItem(ids[1]), fetchItem(ids[2]))
                .map {
                    [$0.0, $0.1, $0.2]
            }
            .eraseToAnyPublisher()
        case 4:
            return Publishers.Zip4(fetchItem(ids[0]), fetchItem(ids[1]), fetchItem(ids[2]), fetchItem(ids[3]))
                .map {
                    [$0.0, $0.1, $0.2, $0.3]
            }
            .eraseToAnyPublisher()
        default:
            return Just([]).eraseToAnyPublisher()
        }
    }
    
    func fetchItem<Item: Decodable>(_ id: Int) -> AnyPublisher<Item, Never> {
        URLSession.shared.dataTaskPublisher(for: Constants.itemURL(for: id))
            .map { $0.data }
            .decode(type: Item?.self, decoder: decoder)
            .catch { _ in
                Just(nil)
        }
        .compactMap {
            $0
        }
        .eraseToAnyPublisher()
    }
}
