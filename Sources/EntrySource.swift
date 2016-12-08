import SwiftyJSON

public struct EntrySource: From, To {

    public typealias T = JSON

    let name: String
    let website: String
    let author: String

    init(name: String, website: String, author: String) {
        self.name = name
        self.website = website
        self.author = author
    }

    public func to() -> JSON {
        let json: JSON = [
            "name": name,
            "website": website,
            "author": author
        ]
        return json
    }

    public static func from(obj: JSON) -> EntrySource {
        let name = obj["name"].string ?? "none"
        let website = obj["website"].string ?? "none"
        let author = obj["author"].string ?? "none"
        return EntrySource(name: name, website: website, author: author)
    }
}
