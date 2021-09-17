import Foundation

struct Episode: Decodable, Identifiable {
    let id: String
    let uri: String
    let name: String
    let parentName: String?
    let released: String
    let difficulty: String?
    let description: String
    
    var domain = ""
    
    var videoURL: VideoURL?
    
    var linkURLString: String {
        "https://www.raywenderlich.com/redirect?uri=" + uri
    }
    
    enum DataKeys: String, CodingKey {
        case id
        case attributes
        case relationships
    }
    
    enum AttrsKeys: String, CodingKey {
        case uri, name, difficulty
        case parentName = "parent_name"
        case releasedAt = "released_at"
        case description = "description_plain_text"
        case videoIdentifier = "video_identifier"
    }
    
    struct Domains: Codable {
        let data: [[String: String]]
    }
    
    enum RelKeys: String, CodingKey {
        case domains
    }
    
    static let domainDictionary = [
        "1": "iOS & Swift",
        "2": "Android & Kotlin",
        "3": "Unity",
        "5": "macOS",
        "8": "Server-Side Swift",
        "9": "Flutter"
    ]
}

extension Episode {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: DataKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        
        let attrs = try container.nestedContainer(keyedBy: AttrsKeys.self, forKey: .attributes)
        let uri = try attrs.decode(String.self, forKey: .uri)
        let name = try attrs.decode(String.self, forKey: .name)
        let parentName = try attrs.decode(String?.self, forKey: .parentName)
        let releasedAt = try attrs.decode(String.self, forKey: .releasedAt)
        let releaseDate = Formatter.iso8601.date(from: releasedAt)!
        let difficulty = try attrs.decode(String?.self, forKey: .difficulty)
        let description = try attrs.decode(String.self, forKey: .description)
        let videoIdentifier = try attrs.decode(Int?.self, forKey: .videoIdentifier)
        
        let rels = try container.nestedContainer(keyedBy: RelKeys.self, forKey: .relationships)
        let domains = try rels.decode( Domains.self, forKey: .domains)
        if let domainId = domains.data.first?["id"] {
            self.domain = Episode.domainDictionary[domainId] ?? ""
        }
        
        self.id = id
        self.uri = uri
        self.name = name
        self.parentName = parentName
        self.released = DateFormatter.episodeDateFormatter.string(from: releaseDate)
        self.difficulty = difficulty
        self.description = description
        if let videoId = videoIdentifier {
            self.videoURL = VideoURL(videoId: videoId)
        }
    }
}
