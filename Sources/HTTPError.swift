import SwiftyJSON

public struct ApiError: To {

    public typealias T = JSON

    let httpStatus: Int
    let problem: String

    init(status: Int, problem: String) {
        self.httpStatus = status
        self.problem = problem
    }

    public func to() -> JSON {
        return [
            "http_status": httpStatus,
            "problem": problem
        ]
    }
}
