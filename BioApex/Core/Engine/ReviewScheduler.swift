import Foundation

// MARK: - 智能复习（SM-2 间隔重复）
// 考点被标记掌握后进入复习排期；答对升档（1/3/7/15/30/60 天），答错回到 1 天。

final class ReviewScheduler: ObservableObject {
    static let shared = ReviewScheduler()

    static let intervals = [1, 3, 7, 15, 30, 60]   // 各档天数

    @Published private(set) var items: [String: ReviewItem] = [:]
    private let key = "bioapex_review_items"

    private init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([String: ReviewItem].self, from: data) {
            items = decoded
        }
    }

    /// 纯函数：给定当前档与对错，返回新档位（便于单测）。
    static func nextLevel(current: Int, correct: Bool) -> Int {
        correct ? min(current + 1, intervals.count - 1) : 0
    }

    func schedule(_ id: String) {
        guard items[id] == nil else { return }
        items[id] = ReviewItem(id: id, level: 0, nextDue: daysFromNow(Self.intervals[0]))
        persist()
    }

    func dueItems(now: Date = Date()) -> [ReviewItem] {
        items.values.filter { $0.nextDue <= now }.sorted { $0.nextDue < $1.nextDue }
    }

    var dueCount: Int { dueItems().count }

    func upcoming() -> [ReviewItem] {
        items.values.filter { $0.nextDue > Date() }.sorted { $0.nextDue < $1.nextDue }
    }

    func review(_ id: String, remembered: Bool) {
        guard var item = items[id] else { return }
        item.level = Self.nextLevel(current: item.level, correct: remembered)
        item.nextDue = daysFromNow(Self.intervals[item.level])
        items[id] = item
        persist()
    }

    private func daysFromNow(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

// MARK: - 错题/薄弱本

final class MistakeManager: ObservableObject {
    static let shared = MistakeManager()

    @Published private(set) var wrongConfusion: Set<String> = []  // 辨析答错的 pair id
    @Published private(set) var weakPoints: Set<String> = []      // 标记为薄弱的考点 id

    private let cKey = "bioapex_wrong_confusion"
    private let pKey = "bioapex_weak_points"

    private init() {
        wrongConfusion = Set(UserDefaults.standard.stringArray(forKey: cKey) ?? [])
        weakPoints = Set(UserDefaults.standard.stringArray(forKey: pKey) ?? [])
    }

    func addConfusion(_ id: String) { wrongConfusion.insert(id); persist() }
    func removeConfusion(_ id: String) { wrongConfusion.remove(id); persist() }

    func toggleWeak(_ id: String) {
        if weakPoints.contains(id) { weakPoints.remove(id) } else { weakPoints.insert(id) }
        persist()
    }
    func isWeak(_ id: String) -> Bool { weakPoints.contains(id) }

    var totalCount: Int { wrongConfusion.count + weakPoints.count }

    private func persist() {
        UserDefaults.standard.set(Array(wrongConfusion), forKey: cKey)
        UserDefaults.standard.set(Array(weakPoints), forKey: pKey)
    }
}
