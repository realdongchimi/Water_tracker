import Foundation

struct DayRecord: Identifiable, Codable, Equatable {
    var id: String { dateKey }      // "YYYY-MM-DD"
    let dateKey: String
    var totalML: Int
    var entries: [DrinkEntry]
}
