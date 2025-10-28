// 메인 상태 기록 관리역할
import SwiftUI
import Combine

final class DrinkStore: ObservableObject {
    @Published private(set) var today: DayRecord
    @Published private(set) var history: [DayRecord] = []

    // 설정
    @AppStorage("goalML") var goalML: Int = 2700  // 목표 섭취량(ml)
    @AppStorage("autoResetEnabled") var autoResetEnabled: Bool = true  // 자동 초기화 사용 여부
    @AppStorage("resetHour") var resetHour: Int = 0  // 자동 초기화 시 (0~23)
    @AppStorage("resetMinute") var resetMinute: Int = 0  // 자동 초기화 분 (0~59)
    @AppStorage("lastSeenKey") private var lastSeenKey: String = "" // 마지막으로 본 날짜키(경계 체크용)

    // 저장 키
    private let todayKeyStorage = "drink_today_v2"
    private let historyKey = "drink_history_v2"

    // 타이머 (경계 체크용)
    // 정확하게 실행을 보장하기 위해
    private var ticker: AnyCancellable?

    // 초기화
    init() {
        // '오늘' 데이터 로드. 없으면 현재 날짜키 기반으로 빈 오늘 생성
        if let cached: DayRecord = Self.loadObject(forKey: todayKeyStorage) {
            self.today = cached
        } else {
            self.today = DayRecord(dateKey: Self.dayKey(for: Date(), resetHour: resetHour, resetMinute: resetMinute),
                                   totalML: 0, entries: [])
        }
        // 히스토리 로드 (없으면 빈 배열)
        self.history = Self.loadObject(forKey: historyKey) ?? []
        handleDayBoundary()
        startMinuteTicker()
    }

    deinit { ticker?.cancel() }

    // 계산 속성
    // 프로그레스 진행률(0.0~1.0)
    var progress: Double {
        guard goalML > 0 else { return 0 }
        return min(Double(today.totalML) / Double(goalML), 1.0)
    }

    // 현재 시각 기준 '하루'의 키 (초기화 시간을 하루 시작으로 간주)
    var currentDayKey: String {
        Self.dayKey(for: Date(), resetHour: resetHour, resetMinute: resetMinute)
    }

    // 물 섭취 추가가
    func addDrink(amount: Int, at time: Date = Date()) {
        guard amount > 0 else { return }
        handleDayBoundary()
        let entry = DrinkEntry(time: time, amount: amount)
        today.entries.append(entry)
        today.totalML += amount
        persist()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    // 특정 기록 삭제
    func deleteEntry(_ entry: DrinkEntry) {
        if let i = today.entries.firstIndex(of: entry) {
            // 총량에서 해당 양을 빼주고 제거
            today.totalML -= max(0, today.entries[i].amount)
            today.entries.remove(at: i)
            persist()
        }
    }

    // 오늘 기록 전체를 0으로 초기화
    func resetToday() {
        today.totalML = 0
        today.entries.removeAll()
        persist()
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    // 자동 초기화 시각을 변경하고 경계를 평가해서 상황에 따라 오늘을 리셋
    func updateResetTime(to date: Date) {
        let c = Calendar.current.dateComponents([.hour, .minute], from: date)
        resetHour = c.hour ?? 0
        resetMinute = c.minute ?? 0
        handleDayBoundary()
        persist()
    }

    // 날짜 경계 처리. 다음날로 넘어갔는지 판단
    func handleDayBoundary() {
        // 자동 초기화 미사용이면 키만 동기화해두고 반환해서 초기화 방지
        guard autoResetEnabled else {
            lastSeenKey = currentDayKey
            cacheToday()
            return
        }
        let nowKey = currentDayKey
        if lastSeenKey.isEmpty { lastSeenKey = nowKey }
        // 마지막으로 본 키와 현재 키가 다르면 다음날로 판단
        if lastSeenKey != nowKey || today.dateKey != nowKey {
            // 어제로 넘겨서 과거 기록을 볼 수 있게 함
            history.append(today)
            // 새로운 오늘 생성
            today = DayRecord(dateKey: nowKey, totalML: 0, entries: [])
            lastSeenKey = nowKey
            persist()
        }
    }

    // today/history를 함께 저장
    private func persist() {
        Self.saveObject(today, forKey: todayKeyStorage)
        Self.saveObject(history, forKey: historyKey)
        objectWillChange.send()
    }

    // today만 캐시에 저장
    private func cacheToday() {
        Self.saveObject(today, forKey: todayKeyStorage)
    }

    // 임의의 Encodable 객체를 JSON으로 인코딩해 UserDfaults에 저장
    private static func saveObject<T: Encodable>(_ obj: T, forKey key: String) {
        let enc = JSONEncoder()
        enc.dateEncodingStrategy = .iso8601
        if let data = try? enc.encode(obj) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    // 임의의 Decodable 객체를 UserDfaults에서 JSON 디코딩해 로드
    private static func loadObject<T: Decodable>(forKey key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601
        return try? dec.decode(T.self, from: data)
    }

    // 포그라운드에서 1분에 한 번씩 날짜 경계를 점검
    private func startMinuteTicker() {
        ticker?.cancel()
        ticker = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.handleDayBoundary() }
    }

    // 사용자 지정 초기화 시각을 하루 시작으로 간주하여 날짜키 문자열을 만듦
    static func dayKey(for date: Date, resetHour: Int, resetMinute: Int) -> String {
        let minutes = resetHour * 60 + resetMinute
        let shifted = Calendar.current.date(byAdding: .minute, value: -minutes, to: date)!
        let c = Calendar.current.dateComponents([.year, .month, .day], from: shifted)
        return String(format: "%04d-%02d-%02d", c.year!, c.month!, c.day!)
    }
}
