import SwiftUI

// MARK: - 段位

enum BioStage: String, Codable {
    case junior     // 初中
    case senior     // 高中必修
    case elective   // 高中选择性必修
    var emoji: String {
        switch self {
        case .junior: return "🌱"
        case .senior: return "🧬"
        case .elective: return "🔬"
        }
    }
    var title: String {
        switch self {
        case .junior: return "初中"
        case .senior: return "高中必修"
        case .elective: return "选择性必修"
        }
    }
    var color: Color {
        switch self {
        case .junior: return .stageJunior
        case .senior: return .stageSenior
        case .elective: return .stageElective
        }
    }
}

// MARK: - 模块（教材模块 + 内购划线）

enum BioModule: String, Codable, CaseIterable, Identifiable {
    case junior        // 初中生物
    case molecule      // 必修1 分子与细胞
    case genetics      // 必修2 遗传与进化
    case homeostasis   // 选必1 稳态与调节
    case ecology       // 选必2 生物与环境
    case biotech       // 选必3 生物技术与工程

    var id: String { rawValue }

    var title: String {
        switch self {
        case .junior:      return "初中生物"
        case .molecule:    return "必修1 · 分子与细胞"
        case .genetics:    return "必修2 · 遗传与进化"
        case .homeostasis: return "选必1 · 稳态与调节"
        case .ecology:     return "选必2 · 生物与环境"
        case .biotech:     return "选必3 · 生物技术与工程"
        }
    }
    var shortTitle: String {
        switch self {
        case .junior:      return "初中"
        case .molecule:    return "必修1"
        case .genetics:    return "必修2"
        case .homeostasis: return "选必1"
        case .ecology:     return "选必2"
        case .biotech:     return "选必3"
        }
    }
    var stage: BioStage {
        switch self {
        case .junior: return .junior
        case .molecule, .genetics: return .senior
        case .homeostasis, .ecology, .biotech: return .elective
        }
    }
    var icon: String {
        switch self {
        case .junior:      return "leaf"
        case .molecule:    return "circle.hexagongrid"
        case .genetics:    return "scribble"
        case .homeostasis: return "arrow.triangle.2.circlepath"
        case .ecology:     return "globe.asia.australia"
        case .biotech:     return "testtube.2"
        }
    }
    var color: Color { stage.color }

    /// 内购划线：初中 + 必修1 永久免费；其余需解锁完整版。
    var isFree: Bool { self == .junior || self == .molecule }
}

// MARK: - 考点（脊梁：考点全图谱的最小单元）

struct KnowledgePoint: Identifiable, Codable {
    let id: String
    let module: BioModule
    let chapter: String          // 章/主题
    let title: String            // 考点名
    let essence: String          // 一句话钩子：先抓住核心
    var weight: Int = 1          // 考频/分值权重 1–3（3=高频高分）
    var commonError: String? = nil   // 易错提示
    var processId: String? = nil     // 关联的过程剧场 id
    // P9 深化四层（默认空，高频考点优先写厚）
    var detail: [String] = []        // 深讲：分条把考点讲透
    var examAngle: String? = nil     // 高考怎么考：常见命题角度
    var memoryAid: String? = nil     // 记忆术 / 口诀
    var related: [String] = []       // 关联考点 id（概念关联网）
    var stage: BioStage { module.stage }
    var isDeepened: Bool { !detail.isEmpty }
}

// MARK: - 过程剧场（生物闪光点：动态过程可视化）

struct ProcessScene: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let module: BioModule
    let location: String         // 发生场所（如：叶绿体类囊体薄膜）
    let examHook: String         // 一句话钩回考点
    let stages: [ProcessStage]
    var isFreeOverride: Bool? = nil
}

struct ProcessStage: Identifiable, Codable {
    let id: String
    let name: String             // 阶段名（如：光反应）
    let detail: String           // 这一步发生了什么
    var consumes: String? = nil  // 消耗
    var produces: String? = nil  // 产生
    var quiz: ProcessQuiz? = nil // 断点填空（选对才继续）
}

struct ProcessQuiz: Codable {
    let prompt: String
    let options: [String]
    let answerIndex: Int
    let explanation: String
}

// MARK: - 生物巨人（情感钩子）

struct BioGiant: Identifiable, Codable {
    let id: String
    let name: String
    let era: String
    let title: String
    let quote: String
    let achievement: String
    let story: String
}

// MARK: - 生命档案馆（生命科学史故事，篇末钩回考点）

struct LoreStory: Identifiable, Codable {
    let id: String
    let icon: String
    let title: String
    let subtitle: String
    let body: String
    let examHook: String
}
