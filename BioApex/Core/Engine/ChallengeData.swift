import Foundation

// MARK: - 破题之眼数据（高考压轴 + 竞赛，巧解）
// 红线：题目与解法均经核对；不臆造具体试题出处。前 2 题免费试看。

enum ChallengeData {
    static let all: [ChallengeProblem] = [
        ChallengeProblem(
            id: "ch_isotope", title: "光合作用释放的 O₂ 从哪来", kind: .gaokao, weapon: .isotope,
            topic: "代谢", difficulty: 3,
            content: "用 H₂¹⁸O 浇灌某植物，同时供给 C¹⁶O₂，在光照下检测其释放的 O₂ 是否含 ¹⁸O，并说明原理。",
            trap: "凭直觉会争论 O₂ 到底来自水还是 CO₂，说不清、易答错。",
            keyInsight: "光合释放的 O₂ 全部来自水的光解——给水标记 ¹⁸O，O₂ 就带 ¹⁸O。",
            steps: ["光反应：H₂¹⁸O 被光解 → 释放 ¹⁸O₂",
                    "C¹⁶O₂ 经暗反应固定、还原 → 不进入 O₂",
                    "若反过来用 C¹⁸O₂、H₂¹⁶O，则释放 ¹⁶O₂，而 ¹⁸O 出现在 C₃、有机物和水中"],
            answer: "释放的 O₂ 含 ¹⁸O（来自水）。",
            takeaway: "凡问「某原子来自哪/去了哪」，用同位素示踪定来源：光合 O₂ 来自水、有氧呼吸生成的水中 O 来自 O₂。"),

        ChallengeProblem(
            id: "ch_energy", title: "能量流动的最多与最少", kind: .gaokao, weapon: .extremeValue,
            topic: "生态", difficulty: 3,
            content: "某食物链 甲→乙→丙→丁。若丁要增重 1 kg，至少、最多需要消耗甲各多少 kg？（能量传递效率 10%~20%）",
            trap: "逐级套效率时，常把「最多/最少」与效率高低搞反。",
            keyInsight: "求「最多消耗」用最低效率 10% 逐级逆推；求「最少消耗」用最高效率 20%。",
            steps: ["最多：1 ÷ 10% ÷ 10% ÷ 10% = 1000 kg",
                    "最少：1 ÷ 20% ÷ 20% ÷ 20% = 125 kg"],
            answer: "最少 125 kg，最多 1000 kg。",
            takeaway: "能量最值：求「消耗最多」用最低效率、「消耗最少」用最高效率；问「最高营养级获得最多」则反过来。"),

        ChallengeProblem(
            id: "ch_hw", title: "隐性病携带者有多少", kind: .olympiad, weapon: .hardyWeinberg,
            topic: "遗传", difficulty: 4,
            content: "某常染色体隐性遗传病在人群中发病率为 1/10000。设人群处于遗传平衡，求携带者(Aa)在人群中的比例。",
            trap: "直接把发病率当基因频率会算错；漏掉开平方这一步。",
            keyInsight: "发病率 = q²，先开平方得隐性基因频率 q，再算携带者 2pq。",
            steps: ["q² = 1/10000 → q = 1/100",
                    "p = 1 − q = 99/100",
                    "携带者 Aa = 2pq = 2 × (99/100) × (1/100) ≈ 1/50 ≈ 2%"],
            answer: "约 2%（1/50）。",
            takeaway: "哈代—温伯格：隐性纯合频率 = q²，开方得 q，杂合 = 2pq——也能解释近亲为何高危。"),

        ChallengeProblem(
            id: "ch_hypothesis", title: "常隐还是伴 X 隐", kind: .gaokao, weapon: .hypothesis,
            topic: "遗传", difficulty: 3,
            content: "一对表现正常的夫妇生了一个患病女儿。如何确定该病是常染色体隐性还是伴 X 隐性遗传？",
            trap: "只能判断是隐性（无中生有），但常隐和 X 隐都能让女儿患病，难直接区分。",
            keyInsight: "假设为伴 X 隐性，则患病女儿 XᵃXᵃ 要求父亲为 XᵃY（应患病）；父亲正常 → 假设矛盾 → 排除。",
            steps: ["无中生有 → 该病为隐性",
                    "假设伴 X 隐性：女儿患病需父亲也患病",
                    "已知父亲表现正常 → 与假设矛盾 → 排除伴 X 隐性",
                    "结论：常染色体隐性遗传"],
            answer: "常染色体隐性遗传。",
            takeaway: "判断遗传方式：先「无中生有/有中生无」定显隐，再用假设法（女病看父、男病看母）排除 X。"),

        ChallengeProblem(
            id: "ch_rq", title: "呼吸商藏着的秘密", kind: .gaokao, weapon: .dataInsight,
            topic: "代谢", difficulty: 3,
            content: "测得某萌发种子在一段时间内 CO₂ 释放量与 O₂ 吸收量的体积比（呼吸商 RQ = CO₂/O₂）为 1.2。判断其呼吸方式。",
            trap: "只想到有氧呼吸，忽略可能同时进行无氧呼吸。",
            keyInsight: "纯糖有氧呼吸 RQ=1；RQ>1 说明还有无氧呼吸（产酒精放 CO₂ 但不耗 O₂）。",
            steps: ["有氧呼吸（葡萄糖）：CO₂ 释放 = O₂ 吸收，RQ = 1",
                    "无氧呼吸（产酒精）：释放 CO₂ 但不吸收 O₂",
                    "RQ = 1.2 > 1 → 同时进行有氧呼吸和产酒精的无氧呼吸"],
            answer: "既进行有氧呼吸，也进行（产生酒精的）无氧呼吸。",
            takeaway: "RQ=1 纯糖有氧；RQ>1 兼有无氧；RQ<1 底物含氧少（如脂肪）。用比值反推呼吸过程。"),
    ]

    static func problem(id: String) -> ChallengeProblem? { all.first { $0.id == id } }
}
