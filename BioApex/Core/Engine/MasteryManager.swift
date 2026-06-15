import SwiftUI

// MARK: - 掌握管理（脊梁：考点掌握闭环 + 覆盖率统计）
// 状态：未学 / 学习中 / 已掌握 / 需复习。题只用于验证掌握与触发复习，不堆题海。

enum MasteryState: String {
    case notStudied, learning, mastered, review
}

final class MasteryManager: ObservableObject {
    static let shared = MasteryManager()

    @Published private(set) var masteredIds: Set<String>
    @Published private(set) var learningIds: Set<String>

    private let masteredKey = "bioapex_mastered_ids"
    private let learningKey = "bioapex_learning_ids"

    private init() {
        masteredIds = Set(UserDefaults.standard.stringArray(forKey: masteredKey) ?? [])
        learningIds = Set(UserDefaults.standard.stringArray(forKey: learningKey) ?? [])
    }

    // MARK: 状态读写

    func state(of id: String) -> MasteryState {
        if masteredIds.contains(id) { return .mastered }
        if learningIds.contains(id) { return .learning }
        return .notStudied
    }

    func markMastered(_ id: String) {
        masteredIds.insert(id)
        learningIds.remove(id)
        persist()
        ReviewScheduler.shared.schedule(id)   // 掌握后进入间隔复习排期
    }

    func markLearning(_ id: String) {
        guard !masteredIds.contains(id) else { return }
        learningIds.insert(id)
        persist()
    }

    func reset(_ id: String) {
        masteredIds.remove(id)
        learningIds.remove(id)
        persist()
    }

    private func persist() {
        UserDefaults.standard.set(Array(masteredIds), forKey: masteredKey)
        UserDefaults.standard.set(Array(learningIds), forKey: learningKey)
    }

    // MARK: 覆盖率统计

    func masteredCount(in points: [KnowledgePoint]) -> Int {
        points.filter { masteredIds.contains($0.id) }.count
    }

    /// 加权覆盖率（按考频权重，更贴近“高考拿分覆盖率”）。
    func weightedCoverage(in points: [KnowledgePoint]) -> Double {
        let total = points.reduce(0) { $0 + $1.weight }
        guard total > 0 else { return 0 }
        let got = points.filter { masteredIds.contains($0.id) }.reduce(0) { $0 + $1.weight }
        return Double(got) / Double(total)
    }

    /// 简单覆盖率（按个数）。
    func coverage(in points: [KnowledgePoint]) -> Double {
        guard !points.isEmpty else { return 0 }
        return Double(masteredCount(in: points)) / Double(points.count)
    }

    var overallMastered: Int { masteredCount(in: SyllabusData.all) }
    var overallTotal: Int { SyllabusData.all.count }
}
