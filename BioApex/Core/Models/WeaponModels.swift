import SwiftUI

// MARK: - 生物解题武器库（家族标配：把"方法"做成可教的能力）
// 何时用(识局) → 怎么用(步骤) → 看例题(破题之眼) → 去哪练。

enum BioWeapon: String, Codable, CaseIterable, Identifiable {
    case isotope        // 同位素示踪法
    case extremeValue   // 极值法
    case hypothesis     // 假设法
    case probability    // 概率拆解（乘法原理）
    case reverse        // 逆推法
    case gamete         // 配子法
    case pedigree       // 系谱判定三步法
    case graphReading   // 坐标曲线三看
    case control        // 实验对照与变量控制
    case scoring        // 采分点规范表述
    case dataInsight    // 数据洞察（由比值/数据反推）
    case hardyWeinberg  // 哈代—温伯格（竞赛）

    var id: String { rawValue }

    var name: String {
        switch self {
        case .isotope:       return "同位素示踪法"
        case .extremeValue:  return "极值法"
        case .hypothesis:    return "假设法"
        case .probability:   return "概率拆解"
        case .reverse:       return "逆推法"
        case .gamete:        return "配子法"
        case .pedigree:      return "系谱判定三步法"
        case .graphReading:  return "坐标曲线三看"
        case .control:       return "对照与变量控制"
        case .scoring:       return "采分点规范表述"
        case .dataInsight:   return "数据洞察"
        case .hardyWeinberg: return "哈代—温伯格"
        }
    }
    var icon: String {
        switch self {
        case .isotope:       return "atom"
        case .extremeValue:  return "arrow.up.arrow.down"
        case .hypothesis:    return "questionmark.diamond"
        case .probability:   return "function"
        case .reverse:       return "arrow.uturn.backward"
        case .gamete:        return "divide"
        case .pedigree:      return "magnifyingglass"
        case .graphReading:  return "chart.xyaxis.line"
        case .control:       return "testtube.2"
        case .scoring:       return "text.append"
        case .dataInsight:   return "eye"
        case .hardyWeinberg: return "percent"
        }
    }
    /// 一句话武器定位。
    var insight: String {
        switch self {
        case .isotope:       return "给原子做标记，追踪它的去向与来源"
        case .extremeValue:  return "推到两个极端，真实答案夹在中间"
        case .hypothesis:    return "先假设一种情况，看是否与结果矛盾"
        case .probability:   return "复杂概率拆成独立事件，分别求再相乘"
        case .reverse:       return "由产物/子代倒推原料/亲代"
        case .gamete:        return "先定配子种类与比例，再组合后代"
        case .pedigree:      return "三步走：判显隐 → 定常/X → 算概率"
        case .graphReading:  return "看轴 → 看点 → 看拐点"
        case .control:       return "单一变量 + 对照 + 等量，让结论可信"
        case .scoring:       return "答到点、用术语，大题靠踩分"
        case .dataInsight:   return "从数据/比值反推过程（如 RQ 判断呼吸类型）"
        case .hardyWeinberg: return "遗传平衡下用 p²+2pq+q²=1 算频率"
        }
    }
    var isOlympiad: Bool { self == .hardyWeinberg }
}

struct WeaponGuide: Identifiable {
    let weapon: BioWeapon
    let tagline: String          // 一句话定位
    let whenToUse: [String]      // 识局信号
    let steps: [String]          // 方法步骤
    var exampleChallengeId: String? = nil   // 破题之眼例题 id
    var practiceHint: String? = nil          // 去哪练
    var id: String { weapon.rawValue }
}
