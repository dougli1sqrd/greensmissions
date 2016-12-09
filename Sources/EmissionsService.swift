import Foundation
import LoggerAPI


public protocol CompanyEmissionsService {

    func makeCompany(name: String) -> Result<CompanyEmissions, ServiceError>

    func viewEmissionsFor(company name: String) -> Result<CompanyEmissions, ServiceError>

    func addEmissionsEntryTo(company name: String, during year: Int, source: EntrySource, yearlyEmissions: [Emission: Int]) -> EmissionsEntry?

    func listEmissionsEntriesFor(company name: String, during year: Int) -> [EmissionsEntry]?

    func findEmissionEntryFor(company name: String, during year: Int, source sourceName: String) -> EmissionsEntry?

    func deleteEntryFor(company name: String, during year: Int, source sourceName: String) -> Bool

    func viewOverallAverageEmissionsFor(company name: String) -> [Emission: Int]?

    func viewAverageEmissionsFor(company name: String, during year: Int) -> [Emission:Int]?
}

//TODO change all places where I"m using an optional to using a custom Result type
class MemoryCompanyEmissionsService: CompanyEmissionsService {

    var companyEmissions: [String:CompanyEmissions]

    init() {
        self.companyEmissions = [:]
    }

    func makeCompany(name: String) -> Result<CompanyEmissions, ServiceError> {
        if companyEmissions[name] != nil {
            return .Err(.companyAlreadyExists(askedFor: name))
        }
        let newCompany = CompanyEmissions(name)
        companyEmissions[name] = newCompany
        return .Ok(newCompany)
    }

    func viewEmissionsFor(company name: String) -> Result<CompanyEmissions, ServiceError> {
        if let theCompany = companyEmissions[name] {
            return .Ok(theCompany)
        } else {
            return .Err(.noSuchCompany(askedFor: name))
        }
    }

    func addEmissionsEntryTo(company name: String, during year: Int, source: EntrySource, yearlyEmissions: [Emission:Int]) -> EmissionsEntry? {

        if var companyData = companyEmissions[name] {
            let currentDate = Date()
            let entry = EmissionsEntry(entered: currentDate, source: source, yearlyEmissions: yearlyEmissions)

            companyData.lastUpdated = currentDate
            companyData.addEmissions(during: year, entry: entry)
            return entry
        } else {
            return nil
        }
    }

    func listEmissionsEntriesFor(company name: String, during year: Int) -> [EmissionsEntry]? {

        return companyEmissions[name]?.listEmissions(during: year)
    }

    func findEmissionEntryFor(company name: String, during year: Int, source sourceName: String) -> EmissionsEntry? {

        if let emissionsForYear = companyEmissions[name]?.listEmissions(during: year) {
            for entry in emissionsForYear {
                if entry.source.name == sourceName {
                    return entry
                }
            }
            return nil
        } else {
            return nil
        }
    }

    func deleteEntryFor(company name: String, during year: Int, source sourceName: String) -> Bool {
        if var companyData = companyEmissions[name] {
            companyData.deleteEmissionEntry(during: year, source: sourceName)
            return true
        } else {
            return false
        }
    }

    func viewOverallAverageEmissionsFor(company name: String) -> [Emission:Int]? {
        if let companyData = companyEmissions[name] {
            var totalEmissions: [Emission:Int] = [
                .co2: 0,
                .methane: 0,
                .nitrousOxide: 0
            ]
            for (year, _) in companyData.emissions {
                let emissionsForYear = viewAverageEmissionsFor(company: name, during: year)! //We know this exists due to iterating
                for (emission, amount) in emissionsForYear {
                    totalEmissions[emission]! += amount
                }
            }
            return [
                .co2: totalEmissions[.co2]!/companyData.emissions.count,
                .methane: totalEmissions[.methane]!/companyData.emissions.count,
                .nitrousOxide: totalEmissions[.methane]!/companyData.emissions.count
            ]
        } else {
            return nil
        }
    }

    func viewAverageEmissionsFor(company name: String, during year: Int) -> [Emission:Int]? {
        if let entries = companyEmissions[name]?.emissions[year] {
            var totalEmissions: [Emission:Int] = [
                .co2: 0,
                .methane: 0,
                .nitrousOxide: 0
            ]
            for entry in entries {
                for (emission, amount) in entry.yearlyEmissions {
                    totalEmissions[emission]! += amount
                }
            }
            return [
                .co2: totalEmissions[.co2]!/entries.count,
                .methane: totalEmissions[.methane]!/entries.count,
                .nitrousOxide: totalEmissions[.nitrousOxide]!/entries.count
            ]
        } else {
            return nil
        }
    }
}

public enum ServiceError: Error {
    case noSuchCompany(askedFor: String)
    case companyAlreadyExists(askedFor: String)
}
