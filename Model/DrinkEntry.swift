import Foundation

// 시간별 섭취 기록
struct DrinkEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var time: Date    // 기록 시각
    var amount: Int    // 섭취량

    init(id: UUID = UUID(), time: Date = Date(), amount: Int) {
        self.id = id
        self.time = time
        self.amount = amount
    }
}
