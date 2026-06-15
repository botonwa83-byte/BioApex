import Foundation

// MARK: - 遗传秒算（双解对决：常规棋盘 vs 分离定律拆解相乘）

struct SolvePath: Codable {
    let title: String
    let steps: [String]
    let minutes: Double
}

struct DuoSolution: Codable {
    let standard: SolvePath
    let shortcut: SolvePath
    var principle: String = ""
    let keyInsight: String
    let plainTalk: String
    var timeRatio: Double { max(standard.minutes / max(shortcut.minutes, 0.1), 1) }
}

struct GeneticsCase: Identifiable, Codable {
    let id: String
    let title: String
    let content: String
    let options: [String]
    let answerIndex: Int
    let explanation: String
    let duo: DuoSolution
}

// MARK: - 遗传神探（系谱破案：逐条揭线索 → 判定遗传方式）

struct PedigreeClue: Identifiable, Codable {
    let id: String
    let text: String        // 线索
    let deduction: String   // 这条线索能推出什么
}

struct PedigreeCase: Identifiable, Codable {
    let id: String
    let title: String
    let scenario: String
    let clues: [PedigreeClue]
    let options: [String]   // 遗传方式选项
    let answerIndex: Int
    let verdict: String     // 结案陈词
}
