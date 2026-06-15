import Foundation

// MARK: - 图表曲线分析（生物高考高频题型：坐标曲线"三看"）

enum GraphShape: String, Codable {
    case sCurve        // S 形（如种群 S 形增长）
    case bell          // 钟形 / 先升后降（如酶活性—温度）
    case saturating    // 上升后饱和（如光合—光照强度）
    case rising        // 持续上升
    case descending    // 持续下降
}

struct GraphCase: Identifiable, Codable {
    let id: String
    let title: String
    let scenario: String
    let xAxis: String          // 横轴含义
    let yAxis: String          // 纵轴含义
    let shape: GraphShape
    let readingPoints: [String] // 三看：关键点/拐点的含义
    let quiz: ProcessQuiz       // 复用：prompt/options/answerIndex/explanation
}
