import Foundation

// MARK: - 题库（按高考权重配题）
// 规则：weight=3 高频考点 每点 ≥2 题（选择+简答采分混配）；weight=2 配 1–2；weight=1 暂不配。
// 红线：题干、答案、采分点、解析均经核对，不臆造试题出处。
// 当前先为已深化的高频考点配题，其余随内容建设增量补齐。

enum QuestionData {
    static let all: [Question] = photosynthesis + respiration + meiosis + mendel + expression + glucose

    static func questions(for kpId: String) -> [Question] { all.filter { $0.kpId == kpId } }
    static func hasQuestions(_ kpId: String) -> Bool { all.contains { $0.kpId == kpId } }

    // 光反应
    private static let photosynthesis: [Question] = [
        Question(id: "q_photo1_c1", kpId: "m1_photo_01", type: .choice,
                 stem: "光合作用光反应阶段，下列说法正确的是？",
                 explanation: "水的光解发生在类囊体薄膜，产生 [H] 和 O₂，并将光能转化为 ATP 中的化学能；O₂ 全部来自水。",
                 options: ["水在类囊体薄膜上被光解，产生 [H] 和 O₂", "暗反应为光反应提供 [H]", "光反应在叶绿体基质中进行", "O₂ 来自 CO₂"],
                 answerIndex: 0),
        Question(id: "q_photo1_s1", kpId: "m1_photo_01", type: .shortAnswer,
                 stem: "突然停止光照，短时间内叶绿体中 C₃ 和 C₅ 含量将如何变化？为什么？",
                 explanation: "停光后光反应停止供应 [H] 和 ATP。",
                 modelAnswer: "C₃ 含量增多，C₅ 含量减少。因为停光后光反应不再提供 [H] 和 ATP，C₃ 还原受阻而积累，同时 CO₂ 仍在被 C₅ 固定生成 C₃，使 C₅ 减少。",
                 scorePoints: ["C₃ 增多、C₅ 减少", "光反应停止、[H] 和 ATP 减少", "C₃ 还原受阻", "CO₂ 固定仍消耗 C₅"]),
        Question(id: "q_photo2_c1", kpId: "m1_photo_02", type: .choice,
                 stem: "暗反应（卡尔文循环）进行的场所和必需条件是？",
                 explanation: "暗反应在叶绿体基质，不直接需光，但需要光反应提供的 [H] 和 ATP 及多种酶。",
                 options: ["叶绿体基质；需光反应供 [H] 和 ATP", "类囊体薄膜；需光", "线粒体基质；需 O₂", "细胞质基质；需 ATP"],
                 answerIndex: 0),
        Question(id: "q_photo2_c2", kpId: "m1_photo_02", type: .choice,
                 stem: "下列属于暗反应中「CO₂ 固定」的反应是？",
                 explanation: "CO₂ 固定：CO₂ + C₅ → 2C₃；C₃ 还原才需要 [H] 和 ATP。",
                 options: ["CO₂ + C₅ → 2C₃", "C₃ + [H] + ATP → (CH₂O) + C₅", "H₂O → [H] + O₂", "ADP + Pi → ATP"],
                 answerIndex: 0),
    ]

    // 有氧呼吸
    private static let respiration: [Question] = [
        Question(id: "q_resp1_c1", kpId: "m1_resp_01", type: .choice,
                 stem: "有氧呼吸过程中，CO₂ 和 H₂O 的生成阶段分别是？",
                 explanation: "CO₂ 在第二阶段（线粒体基质，丙酮酸分解）生成；H₂O 在第三阶段（线粒体内膜，[H]+O₂）生成。",
                 options: ["CO₂ 第二阶段、H₂O 第三阶段", "都在第一阶段", "CO₂ 第三阶段、H₂O 第二阶段", "都在线粒体内膜"],
                 answerIndex: 0),
        Question(id: "q_resp1_s1", kpId: "m1_resp_01", type: .shortAnswer,
                 stem: "为什么有氧呼吸释放的能量远多于无氧呼吸？",
                 explanation: "有氧呼吸把有机物彻底氧化分解。",
                 modelAnswer: "有氧呼吸中有机物被彻底氧化分解为 CO₂ 和 H₂O，[H] 经第三阶段与 O₂ 结合释放大量能量；无氧呼吸只把葡萄糖分解为酒精或乳酸，分解不彻底，释放能量少。",
                 scorePoints: ["有氧呼吸彻底氧化分解为 CO₂ 和 H₂O", "[H] 与 O₂ 结合释放大量能量", "无氧呼吸分解不彻底（生成酒精/乳酸）"]),
    ]

    // 减数分裂
    private static let meiosis: [Question] = [
        Question(id: "q_meio_c1", kpId: "g_meiosis_01", type: .choice,
                 stem: "同源染色体的分开发生在减数分裂的？",
                 explanation: "同源染色体在减Ⅰ后期分开（使染色体数目减半）；姐妹染色单体在减Ⅱ后期分开。",
                 options: ["减Ⅰ后期", "减Ⅱ后期", "减Ⅰ前期", "减Ⅱ中期"],
                 answerIndex: 0),
        Question(id: "q_meio_c2", kpId: "g_meiosis_01", type: .choice,
                 stem: "一个基因型为 AaBb（两对基因独立）的精原细胞，减数分裂可产生几种精子？",
                 explanation: "一个精原细胞减数分裂只产生 2 种（4 个）精子；一个个体（许多细胞）才可能产生 4 种。",
                 options: ["2 种", "4 种", "1 种", "8 种"],
                 answerIndex: 0),
    ]

    // 分离 / 自由组合
    private static let mendel: [Question] = [
        Question(id: "q_mendel1_c1", kpId: "g_mendel_01", type: .choice,
                 stem: "基因型 Aa 的个体自交，后代表现型及比例（完全显性）为？",
                 explanation: "Aa×Aa → 1AA:2Aa:1aa，表现型显:隐 = 3:1。",
                 options: ["显性:隐性 = 3:1", "全为显性", "1:1", "1:2:1"],
                 answerIndex: 0),
        Question(id: "q_mendel1_c2", kpId: "g_mendel_01", type: .choice,
                 stem: "测交（Aa × aa）后代的表现型比例是？该方法常用来？",
                 explanation: "测交后代 1Aa:1aa，即显:隐 = 1:1，常用来测定显性个体的基因型。",
                 options: ["1:1；测定 F₁ 的基因型", "3:1；测定显隐性", "1:2:1；判断纯合子", "全显性；鉴定纯合"],
                 answerIndex: 0),
        Question(id: "q_mendel2_c1", kpId: "g_mendel_02", type: .choice,
                 stem: "AaBb×AaBb（两对独立），后代中 aabb 的比例是？",
                 explanation: "拆分相乘：aa 占 1/4，bb 占 1/4，相乘 = 1/16。",
                 options: ["1/16", "9/16", "1/4", "3/16"],
                 answerIndex: 0),
        Question(id: "q_mendel2_s1", kpId: "g_mendel_02", type: .shortAnswer,
                 stem: "AaBb×AaBb（两对独立遗传），求后代表现型为「双显性」(A_B_) 的概率，并说明用了什么方法。",
                 explanation: "自由组合题拆成分离定律相乘。",
                 modelAnswer: "A_ 占 3/4、B_ 占 3/4，相乘得 A_B_ = 9/16。方法：把自由组合拆成两个分离定律，分别求概率再相乘。",
                 scorePoints: ["A_ = 3/4、B_ = 3/4", "相乘 = 9/16", "拆成分离定律再相乘（乘法原理）"]),
    ]

    // 基因表达
    private static let expression: [Question] = [
        Question(id: "q_expr_c1", kpId: "g_expr_01", type: .choice,
                 stem: "决定一个氨基酸的密码子位于？",
                 explanation: "密码子在 mRNA 上，每 3 个相邻碱基为一个密码子；tRNA 上是反密码子。",
                 options: ["mRNA 上", "tRNA 上", "DNA 模板链上", "核糖体上"],
                 answerIndex: 0),
        Question(id: "q_expr_s1", kpId: "g_expr_01", type: .shortAnswer,
                 stem: "一个含 900 个碱基的基因（编码区连续），最多可指导合成含多少个氨基酸的蛋白质？写出推算。",
                 explanation: "基因(DNA)碱基:mRNA碱基:氨基酸 = 6:3:1。",
                 modelAnswer: "约 150 个。基因双链 900 个碱基，对应 mRNA 450 个碱基（一条链转录），每 3 个碱基决定 1 个氨基酸，900÷6=150（不计终止密码子）。",
                 scorePoints: ["碱基∶氨基酸 = 6∶1", "900÷6 = 150", "（终止密码子不编码氨基酸，实际略少）"]),
    ]

    // 血糖调节
    private static let glucose: [Question] = [
        Question(id: "q_glu_c1", kpId: "h_humor_01", type: .choice,
                 stem: "下列关于血糖调节的叙述，正确的是？",
                 explanation: "胰岛素是唯一降血糖的激素，由胰岛 B 细胞分泌；胰高血糖素升血糖，两者拮抗。",
                 options: ["胰岛素是唯一能降低血糖的激素", "胰高血糖素由胰岛 B 细胞分泌", "胰岛素促进肝糖原分解", "二者作用相同"],
                 answerIndex: 0),
        Question(id: "q_glu_s1", kpId: "h_humor_01", type: .shortAnswer,
                 stem: "饭后血糖升高时，机体如何把血糖降回正常？（写出主要激素与作用）",
                 explanation: "血糖升高→胰岛B细胞→胰岛素。",
                 modelAnswer: "血糖升高刺激胰岛 B 细胞分泌胰岛素增多；胰岛素促进组织细胞摄取、利用和储存葡萄糖（合成肝糖原、肌糖原），并抑制肝糖原分解和非糖物质转化为葡萄糖，从而使血糖降回正常。这属于（负）反馈调节。",
                 scorePoints: ["胰岛 B 细胞分泌胰岛素增多", "促进摄取、利用、储存（合成糖原）", "抑制糖原分解和非糖物质转化", "负反馈调节"]),
    ]
}
