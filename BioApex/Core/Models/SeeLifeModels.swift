import Foundation

// MARK: - 细胞图鉴

enum CellPresence: String, Codable {
    case both, plantOnly, animalOnly
    var label: String {
        switch self {
        case .both: return "动植物共有"
        case .plantOnly: return "植物特有"
        case .animalOnly: return "动物特有"
        }
    }
}

struct Organelle: Identifiable, Codable {
    let id: String
    let name: String
    let icon: String
    let structure: String     // 结构特点
    let function: String      // 功能
    var examHeat: Int = 1     // 考点热度 1–3
    let presence: CellPresence
    var relatedProcessId: String? = nil
    var membrane: String = "" // 膜层情况（如：双层膜/单层膜/无膜）
}

// MARK: - 生命的尺度（结构层次）

struct ScaleLevel: Identifiable, Codable {
    let id: String
    let order: Int
    let name: String
    let scale: String         // 尺度量级，如 ~10 μm
    let summary: String
    let example: String
    var isLifeSystem: Bool = true   // 是否属于"生命系统的结构层次"
    var note: String? = nil
}
