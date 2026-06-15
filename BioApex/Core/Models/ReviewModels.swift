import Foundation

// MARK: - 易混辨析对决

struct ConfusionRow: Identifiable, Codable {
    var id: String { dimension }
    let dimension: String   // 对比维度
    let left: String
    let right: String
}

struct ConfusionQuiz: Identifiable, Codable {
    let id: String
    let statement: String   // 一句描述，判断它属于左还是右
    let answerIsLeft: Bool
    let explanation: String
}

struct ConfusionPair: Identifiable, Codable {
    let id: String
    let title: String
    let leftName: String
    let rightName: String
    let rows: [ConfusionRow]
    let quizzes: [ConfusionQuiz]
}

// MARK: - 智能复习（SM-2 间隔重复）

struct ReviewItem: Codable {
    let id: String          // 考点 id
    var level: Int          // 档位 0..5
    var nextDue: Date
}
