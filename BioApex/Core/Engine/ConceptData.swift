import SwiftUI

// MARK: - 生命观念（核心素养）+ 概念关联网分组
// 把零散考点按 4 大生命观念串成网;映射可随内容增量扩充。

enum LifeConcept: String, CaseIterable, Identifiable {
    case structureFunction   // 结构与功能观
    case matterEnergy        // 物质与能量观
    case homeostasis         // 稳态与平衡观
    case evolution           // 进化与适应观

    var id: String { rawValue }
    var title: String {
        switch self {
        case .structureFunction: return "结构与功能观"
        case .matterEnergy:      return "物质与能量观"
        case .homeostasis:       return "稳态与平衡观"
        case .evolution:         return "进化与适应观"
        }
    }
    var subtitle: String {
        switch self {
        case .structureFunction: return "结构决定功能，功能依赖结构"
        case .matterEnergy:      return "生命活动伴随物质变化与能量流动"
        case .homeostasis:       return "内外环境的动态平衡靠调节维持"
        case .evolution:         return "适应是自然选择与进化的结果"
        }
    }
    var icon: String {
        switch self {
        case .structureFunction: return "cube.transparent"
        case .matterEnergy:      return "bolt.circle"
        case .homeostasis:       return "arrow.triangle.2.circlepath"
        case .evolution:         return "tree"
        }
    }
    var color: Color {
        switch self {
        case .structureFunction: return .bioBlue
        case .matterEnergy:      return .bioGreen
        case .homeostasis:       return .bioTeal
        case .evolution:         return .bioPurple
        }
    }
}

enum ConceptData {
    /// 生命观念 → 关联考点 id（持续增量）。
    static let map: [LifeConcept: [String]] = [
        .structureFunction: ["m1_cell_01", "m1_cell_02", "m1_cell_03", "m1_mol_03", "m1_aa_01"],
        .matterEnergy:      ["m1_photo_01", "m1_photo_02", "m1_resp_01", "m1_enzyme_02", "e_eco_06", "e_eco_07"],
        .homeostasis:       ["h_env_01", "h_humor_01", "h_nerve_01", "h_immune_01", "e_eco_09"],
        .evolution:         ["g_evo_01", "g_evo_02", "g_var_01", "g_coevo", "g_meiosis_01"],
    ]

    static func points(for concept: LifeConcept) -> [KnowledgePoint] {
        (map[concept] ?? []).compactMap { SyllabusData.point(id: $0) }
    }
}
