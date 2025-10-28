import Foundation

struct DrinkEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var time: Date
    var amount: Int

    init(id: UUID = UUID(), time: Date = Date(), amount: Int) {
        self.id = id
        self.time = time
        self.amount = amount
    }
}
