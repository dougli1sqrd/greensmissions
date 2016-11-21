import Foundation

public struct EmissionsEntry {

    let entered: Date
    let source: EntrySource
    var yearlyEmissions: [Emission: Int]

    init(entered: Date, source: EntrySource, yearlyEmissions: [Emission: Int]) {
        self.entered = entered
        self.source = source
        self.yearlyEmissions = yearlyEmissions
    }
}
