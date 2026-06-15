import SwiftUI

// MARK: - 破题之眼：高考压轴 + 生物竞赛的巧解（天花板/向上仰望模块）
// 与武器库共用 BioWeapon：每道压轴题用一把武器破解。

enum ChallengeKind: String, Codable {
    case gaokao      // 高考压轴
    case olympiad    // 生物竞赛
    var label: String { self == .gaokao ? "高考压轴" : "生物竞赛" }
    var color: Color { self == .gaokao ? .bioGold : .bioPurple }
}

struct ChallengeProblem: Identifiable, Codable {
    let id: String
    let title: String
    let kind: ChallengeKind
    let weapon: BioWeapon       // 用哪把武器破解
    let topic: String           // 遗传 / 代谢 / 生态 …
    let difficulty: Int         // 难度 1–5（🔥）
    let content: String         // 题干
    let trap: String            // 常规思路为何吃力
    let keyInsight: String       // 巧解关键（一句识局）
    let steps: [String]         // 巧解步骤
    let answer: String          // 答案
    let takeaway: String        // 方法迁移：这招还能用在哪
}
