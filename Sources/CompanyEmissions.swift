import Foundation
import SwiftyJSON

public struct CompanyEmissions: To, From {

    let name: String
    var emissions: [Int: [EmissionsEntry]]
    var lastUpdated: Date

    public typealias T = JSON

    init(_ name: String) {
        self.name = name
        emissions = [:]
        lastUpdated = Date()
    }

    mutating func addEmissions(during year: Int, entry: EmissionsEntry) {
        if emissions[year] == nil {
            emissions[year] = []
        }
        emissions[year]?.append(entry)
    }

    mutating func deleteEmissionEntry(during year: Int, source: String) {
        if emissions[year] != nil {
            emissions[year] = emissions[year]!.filter {$0.source.name != source}
        }
    }

    func listEmissions(during year: Int) -> [EmissionsEntry]? {
        return emissions[year]
    }

    public func to() -> JSON {

        var json: JSON = [
            "name": self.name,
            "last_updated": DateTime.toString(date: lastUpdated)
        ]

        for (year, entries) in self.emissions {
            var emissionsEntries: [JSON] = []
            for entry in entries {
                emissionsEntries.append(entry.to())
            }
            json["emissions"].dictionaryObject = [String(year): emissionsEntries]
        }
        return json
    }

    public static func from(obj: JSON) -> CompanyEmissions {
        //TODO Bad, we're assuming this works
        let updated = DateTime.asDate(date: obj["last_updated"].stringValue)!

        var emissionsByYear: [Int:[EmissionsEntry]] = [:]
        for (year, emissionsEntriesJson): (String, JSON) in obj["emissions"] {
            var emissionsEntries: [EmissionsEntry] = []
            for entry in emissionsEntriesJson.arrayValue {
                emissionsEntries.append(EmissionsEntry.from(obj: entry))
            }
            emissionsByYear[Int(year)!] = emissionsEntries
        }

        let name = obj["name"].stringValue
        var companyEmissions = CompanyEmissions(name)

        companyEmissions.lastUpdated = updated
        companyEmissions.emissions = emissionsByYear

        return companyEmissions
    }
}
