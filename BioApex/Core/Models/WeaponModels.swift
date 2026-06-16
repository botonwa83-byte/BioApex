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
    case baseCount      // 碱基计算与中心法则数量关系
    case crossDesign    // 杂交方案设计（鉴定显隐/纯合）
    case linkage        // 连锁互换与基因定位
    case energyBudget   // 能量收支分配
    case gasExchange    // 光合呼吸"三量"与装置
    case divisionImage  // 细胞分裂图像与数目曲线
    case osmosis        // 渗透与水分移动
    case variationType  // 变异类型判定
    case geneticDiagram // 遗传图解规范书写
    case specialRatio   // 特殊分离比（9:3:3:1 变式与致死）
    case populationModel // 种群增长模型（J/S 型、λ、K/2）
    case assignValue    // 赋值法（设具体值化简计算）
    case microCount     // 微生物计数（稀释涂布/血球板）
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
        case .baseCount:     return "碱基计算"
        case .crossDesign:   return "杂交方案设计"
        case .linkage:       return "连锁与基因定位"
        case .energyBudget:  return "能量收支分配"
        case .gasExchange:   return "光合呼吸三量"
        case .divisionImage: return "分裂图像判读"
        case .osmosis:       return "渗透与水分"
        case .variationType: return "变异类型判定"
        case .geneticDiagram: return "遗传图解规范"
        case .specialRatio:  return "特殊分离比"
        case .populationModel: return "种群增长模型"
        case .assignValue:   return "赋值法"
        case .microCount:    return "微生物计数"
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
        case .baseCount:     return "number"
        case .crossDesign:   return "arrow.triangle.branch"
        case .linkage:       return "link"
        case .energyBudget:  return "chart.pie.fill"
        case .gasExchange:   return "wind"
        case .divisionImage: return "circle.hexagongrid.fill"
        case .osmosis:       return "drop.fill"
        case .variationType: return "shuffle"
        case .geneticDiagram: return "list.bullet.rectangle"
        case .specialRatio:  return "divide.circle"
        case .populationModel: return "chart.line.uptrend.xyaxis"
        case .assignValue:   return "n.square"
        case .microCount:    return "circle.grid.3x3.fill"
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
        case .baseCount:     return "互补配对 + 中心法则，把碱基/氨基酸数量算清"
        case .crossDesign:   return "用自交/测交设计实验，鉴定显隐性与纯合杂合"
        case .linkage:       return "由后代比例偏离识别连锁，重组率≈图距"
        case .energyBudget:  return "摄入=同化+粪便，同化=呼吸+生长，逐项分配"
        case .gasExchange:   return "净光合+呼吸=总光合，黑白瓶分清三量"
        case .divisionImage: return "看染色体行为，定有丝/减数与时期"
        case .osmosis:       return "比浓度定吸水失水，质壁分离会不会复原"
        case .variationType: return "可遗传三选一：突变·重组·染色体变异"
        case .geneticDiagram: return "亲本→配子→子代，规范写出遗传图解"
        case .specialRatio:  return "9:3:3:1 变了形，本质仍是自由组合"
        case .populationModel: return "J 型看 λ、S 型看 K/2，模型定增减"
        case .assignValue:   return "未知设具体值，把抽象比例变好算的数"
        case .microCount:    return "菌落数 × 稀释倍数 ÷ 体积，活菌偏小"
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
