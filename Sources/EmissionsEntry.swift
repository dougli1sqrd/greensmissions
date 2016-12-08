import Foundation
import SwiftyJSON

public struct EmissionsEntry: To {

    public typealias T = JSON

    let entered: Date
    let source: EntrySource
    var yearlyEmissions: [Emission: Int]

    init(entered: Date, source: EntrySource, yearlyEmissions: [Emission: Int]) {
        self.entered = entered
        self.source = source
        self.yearlyEmissions = yearlyEmissions
    }

    public func to() -> JSON {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DDThh:mm:ss.s"
        formatter.timeZone = TimeZone(identifier: "UTC")

        var json: JSON = [
            "entered": formatter.string(from: entered),
            "source": source.to()
        ]
        var emissions: [String:Int] = [:]
        for (emission, amount) in yearlyEmissions {
            emissions[String(describing: emission)] = amount
        }
        json["yearly_emissions"] = JSON(emissions)
        return json
    }

    public static func from(obj: JSON) -> EmissionsEntry {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DDThh:mm:ss.s"
        formatter.timeZone = TimeZone(identifier: "UTC")
        //TODO This assumes that entered exists
        let enteredDate = formatter.date(from: obj["entered"].string!)

        let source = EntrySource.from(obj: obj["source"])

        var emissions: [Emission:Int] = [:]
        for (emission, amount) in obj["yearly_emissions"] {
            //TODO This assumes fromString will work. Also this is bad.
            emissions[Emission.fromString(emission)!] = amount.int
        }
        return EmissionsEntry(entered: enteredDate ?? Date(), source: source, yearlyEmissions: emissions)
    }
}
