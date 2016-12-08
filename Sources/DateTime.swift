import Foundation

struct DateTime {

    /**
    Converts a date instance to a string representation using a default Format.
    */
    static func toString(date: Date) -> String {
        return buildFormatter().string(from: date)
    }

    /**
    Converts a String in the correct date format to a Date object.
    */
    static func asDate(date: String) -> Date? {
        return buildFormatter().date(from: date)
    }

    /**
    Builds the DateFormatter to be used with this project
    */
    private static func buildFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd\'T\'hh:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }
}
