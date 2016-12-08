
public enum Result<T, E:Error> {
    case Ok(T)
    case Err(E)
}
