import SwiftUI
import Combine

final class DrinkStore: ObservableObject {
    @Published private(set) var today: DayRecord
    @Published private(set) var history: [DayRecord] = []

    // 설정
    @AppStorage("goalML") var goalML: Int = 2700  //목표량
    @AppStorage("autoResetEnabled") var autoResetEnabled: Bool = true  //자동 초기화
    @AppStorage("resetHour") var resetHour: Int = 0  //초기화 시
    @AppStorage("resetMinute") var resetMinute: Int = 0  //초기화 분
    @AppStorage("lastSeenKey") private var lastSeenKey: String = "" 

    // 저장 키
    private let todayKeyStorage = "drink_today_v2"
    private let historyKey = "drink_history_v2"

    // 타이커
    private var ticker: AnyCancellable?

    // 초기화
    init() {
        if let cached: DayRecord = Self.loadObject(forKey: todayKeyStorage) {
            self.today = cached
        } else {
            self.today = DayRecord(dateKey: Self.dayKey(for: Date(), resetHour: resetHour, resetMinute: resetMinute),
                                   totalML: 0, entries: [])
        }
        self.history = Self.loadObject(forKey: historyKey) ?? []
        handleDayBoundary()
        startMinuteTicker()
    }

    deinit { ticker?.cancel() }

    // 계산 속성
    var progress: Double {
        guard goalML > 0 else { return 0 }
        return min(Double(today.totalML) / Double(goalML), 1.0)
    }

    var currentDayKey: String {
        Self.dayKey(for: Date(), resetHour: resetHour, resetMinute: resetMinute)
    }

    // Intent
    func addDrink(amount: Int, at time: Date = Date()) {
        guard amount > 0 else { return }
        handleDayBoundary()
        let entry = DrinkEntry(time: time, amount: amount)
        today.entries.append(entry)
        today.totalML += amount
        persist()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    func deleteEntry(_ entry: DrinkEntry) {
        if let i = today.entries.firstIndex(of: entry) {
            today.totalML -= max(0, today.entries[i].amount)
            today.entries.remove(at: i)
            persist()
        }
    }

    func resetToday() {
        today.totalML = 0
        today.entries.removeAll()
        persist()
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    func updateResetTime(to date: Date) {
        let c = Calendar.current.dateComponents([.hour, .minute], from: date)
        resetHour = c.hour ?? 0
        resetMinute = c.minute ?? 0
        handleDayBoundary()
        persist()
    }

    func handleDayBoundary() {
        guard autoResetEnabled else {
            lastSeenKey = currentDayKey
            cacheToday()
            return
        }
        let nowKey = currentDayKey
        if lastSeenKey.isEmpty { lastSeenKey = nowKey }
        if lastSeenKey != nowKey || today.dateKey != nowKey {
            history.append(today)
            today = DayRecord(dateKey: nowKey, totalML: 0, entries: [])
            lastSeenKey = nowKey
            persist()
        }
    }

    // 저장
    private func persist() {
        Self.saveObject(today, forKey: todayKeyStorage)
        Self.saveObject(history, forKey: historyKey)
        objectWillChange.send()
    }

    private func cacheToday() {
        Self.saveObject(today, forKey: todayKeyStorage)
    }

    private static func saveObject<T: Encodable>(_ obj: T, forKey key: String) {
        let enc = JSONEncoder()
        enc.dateEncodingStrategy = .iso8601
        if let data = try? enc.encode(obj) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private static func loadObject<T: Decodable>(forKey key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601
        return try? dec.decode(T.self, from: data)
    }

    private func startMinuteTicker() {
        ticker?.cancel()
        ticker = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.handleDayBoundary() }
    }

    static func dayKey(for date: Date, resetHour: Int, resetMinute: Int) -> String {
        let minutes = resetHour * 60 + resetMinute
        let shifted = Calendar.current.date(byAdding: .minute, value: -minutes, to: date)!
        let c = Calendar.current.dateComponents([.year, .month, .day], from: shifted)
        return String(format: "%04d-%02d-%02d", c.year!, c.month!, c.day!)
    }
}
