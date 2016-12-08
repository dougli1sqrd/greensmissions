
public protocol From {
    associatedtype T

    static func from(obj: T) -> Self
}

public protocol To {
    associatedtype T

    func to() -> T
}
