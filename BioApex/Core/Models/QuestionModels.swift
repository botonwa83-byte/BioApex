import Foundation

// MARK: - 练习题（按高考权重配题；题用于验证掌握，不堆题海）

enum QuestionType: String, Codable {
    case choice        // 选择题（概念辨析）
    case shortAnswer   // 简答题（采分点，自评对照）
    var label: String { self == .choice ? "选择" : "简答·采分" }
}

struct Question: Identifiable, Codable {
    let id: String
    let kpId: String              // 所属考点
    let type: QuestionType
    let stem: String              // 题干
    let explanation: String       // 解析
    // 选择题
    var options: [String] = []
    var answerIndex: Int = 0
    // 简答题（采分点）
    var modelAnswer: String = ""
    var scorePoints: [String] = []
}
