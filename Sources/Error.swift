import SwiftyJSON
import KituraNet

/**
Api type that represents returning an error as JSON to the client
*/
public struct HTTPError: To {

    public typealias T = JSON

    let httpStatus: KituraNet.HTTPStatusCode
    let problem: String

    init(status: KituraNet.HTTPStatusCode, problem: String) {
        self.httpStatus = status
        self.problem = problem
    }

    public func to() -> JSON {
        return [
            "http_status": httpStatus.rawValue,
            "problem": problem
        ]
    }
}
