import Foundation

struct DayRecord: Identifiable, Codable, Equatable {
    var id: String { dateKey }      // "YYYY-MM-DD"
    let dateKey: String    // 시간 지정하기 위한 날짜키
    var totalML: Int    // 해당 날짜 중 섭취량
    var entries: [DrinkEntry]    // 시간별 기록 리스트
}
