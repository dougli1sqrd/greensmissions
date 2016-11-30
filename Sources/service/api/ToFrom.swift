
protocol From {
    associatedtype T

    static func from(obj: T) -> Self
}

protocol To {
    associatedtype T

    func to() -> T
}
