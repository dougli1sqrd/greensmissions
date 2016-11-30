
public enum Emission {
    case co2
    case methane
    case nitrousOxide

    static func fromString(_ s: String) -> Emission? {
        switch s {
        case "co2":
            return .co2
        case "methane":
            return .methane
        case "nitrousOxide":
            return .nitrousOxide

        default:
            return nil
        }
    }
}
