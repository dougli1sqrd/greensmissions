import Foundation

public struct CompanyEmissions {

    let name: String
    var emissions: [Int: [EmissionsEntry]]
    var lastUpdated: Date

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
}
