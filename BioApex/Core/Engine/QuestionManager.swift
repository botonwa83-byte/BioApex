import Foundation

// MARK: - 练习题作答记录 + 以"做对题"判定考点掌握

final class QuestionManager: ObservableObject {
    static let shared = QuestionManager()

    @Published private(set) var correctIds: Set<String> = []   // 已做对的题 id
    private let key = "bioapex_correct_questions"

    private init() {
        correctIds = Set(UserDefaults.standard.stringArray(forKey: key) ?? [])
    }

    func isCorrect(_ qid: String) -> Bool { correctIds.contains(qid) }

    func markCorrect(_ qid: String) {
        guard !correctIds.contains(qid) else { return }
        correctIds.insert(qid)
        UserDefaults.standard.set(Array(correctIds), forKey: key)
    }

    /// 某考点是否已"做对全部诊断题" → 视为已验证掌握。
    func isKpVerified(_ kpId: String) -> Bool {
        let qs = QuestionData.questions(for: kpId)
        guard !qs.isEmpty else { return false }
        return qs.allSatisfy { correctIds.contains($0.id) }
    }

    /// 某考点已做对的题数 / 总题数。
    func progress(for kpId: String) -> (done: Int, total: Int) {
        let qs = QuestionData.questions(for: kpId)
        return (qs.filter { correctIds.contains($0.id) }.count, qs.count)
    }
}
