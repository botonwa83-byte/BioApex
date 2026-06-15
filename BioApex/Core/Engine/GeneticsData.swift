import Foundation

// MARK: - 遗传秒算 + 遗传神探数据
// 红线：所有概率均经验算；系谱判定符合"无中生有为隐、有中生无为显"等规则。

enum GeneticsData {

    // MARK: 遗传秒算（双解对决）

    static let duels: [GeneticsCase] = [
        GeneticsCase(
            id: "gd_freecomb", title: "自由组合 · 求显性组合比例",
            content: "基因型为 AaBb 的个体自交（AaBb × AaBb，两对基因独立遗传），后代中两对性状均为显性（A_B_）的比例是？",
            options: ["9/16", "3/16", "1/16", "3/4"],
            answerIndex: 0,
            explanation: "拆成两个分离定律：Aa×Aa→A_ 占 3/4；Bb×Bb→B_ 占 3/4；相乘 3/4×3/4=9/16。",
            duo: DuoSolution(
                standard: SolvePath(title: "常规解：画 16 格棋盘", steps: [
                    "写出 AaBb 产生的 4 种配子 AB、Ab、aB、ab",
                    "画 4×4 = 16 格棋盘逐格组合",
                    "数出含 A 且含 B 的格子共 9 个",
                    "得 9/16（易数错、耗时）",
                ], minutes: 4),
                shortcut: SolvePath(title: "秒算：分离定律拆解相乘", steps: [
                    "Aa×Aa → 显性 A_ 概率 3/4",
                    "Bb×Bb → 显性 B_ 概率 3/4",
                    "独立事件相乘：3/4 × 3/4 = 9/16 ✓",
                ], minutes: 0.5),
                principle: "原理：自由组合定律的本质是两对（位于非同源染色体上的）基因互不干扰、独立遗传。既然独立，每对性状就各自服从分离定律，求「同时满足」的概率就把各对的概率相乘即可——这正是概率论里独立事件的乘法法则，所以根本不必画 16 格棋盘。",
                keyInsight: "多对独立基因求某组合概率：每对按分离定律单独算，再相乘。",
                plainTalk: "两对基因互不打扰，那就分开算：A 这对里显性占四分之三，B 那对也占四分之三，要两样都显性，乘起来就是十六分之九。棋盘是给它们硬凑，乘法才是捷径。")),

        GeneticsCase(
            id: "gd_carrier", title: "患病概率 · 正常孩子是携带者吗",
            content: "某常染色体隐性遗传病，一对均为携带者（Aa）的夫妇生育。他们所生孩子表现正常、但为携带者(Aa)的概率是？",
            options: ["2/3", "1/2", "1/4", "3/4"],
            answerIndex: 0,
            explanation: "Aa×Aa→1AA:2Aa:1aa。患病(aa)占 1/4；正常占 3/4(1AA:2Aa)。在「正常孩子」范围内，携带者占 2/3。",
            duo: DuoSolution(
                standard: SolvePath(title: "常规解：列全部基因型再筛", steps: [
                    "Aa×Aa 后代 1AA : 2Aa : 1aa",
                    "患病 aa = 1/4，正常 = 3/4",
                    "题问的是「正常孩子」里的携带者比例",
                    "需要在 3/4 里再求 Aa 占比，容易直接答成 1/2",
                ], minutes: 2.5),
                shortcut: SolvePath(title: "秒算：限定范围内的条件概率", steps: [
                    "正常孩子只有 AA 和 Aa，比例 1 : 2",
                    "携带者 Aa 在正常中占 2/(1+2) = 2/3 ✓",
                ], minutes: 0.5),
                principle: "原理：题目把范围限定在了「表现正常的孩子」里，这是条件概率——分母不再是全部后代，而只是正常后代(AA:Aa=1:2)。把患病的 aa 先剔除，再在剩下的里算 Aa 的占比，就是 2/3。看清「在……之中」这几个字是关键。",
                keyInsight: "见到「在正常个体中」先剔除患病个体，再在剩余里求比例（条件概率）。",
                plainTalk: "孩子要么 AA、要么 Aa、要么 aa，比例 1:2:1。题目说「已经正常了」，那 aa 就不算了，只在 1 份 AA 和 2 份 Aa 里挑，携带者就是三分之二。别一看到 Aa 就答二分之一。")),
    ]

    // MARK: 遗传神探（系谱破案）

    static let pedigrees: [PedigreeCase] = [
        PedigreeCase(
            id: "pd_auto_rec", title: "无中生有的怪病",
            scenario: "一对表现都正常的夫妇，生下了一个患某遗传病的女儿。请判断该病的遗传方式。",
            clues: [
                PedigreeClue(id: "c1", text: "父母双方都不患病，却生出了患病的孩子。",
                             deduction: "“无中生有”——后代出现了双亲没有的性状，说明患病是隐性性状。"),
                PedigreeClue(id: "c2", text: "患病的是女儿。",
                             deduction: "女性患者。若为伴 X 隐性，女儿患病(XᵃXᵃ)要求父亲也是 XᵃY，即父亲应患病。"),
                PedigreeClue(id: "c3", text: "女儿的父亲表现正常、不患病。",
                             deduction: "父亲正常 → 排除伴 X 隐性（否则父亲必患）→ 基因在常染色体上。"),
            ],
            options: ["常染色体隐性遗传", "常染色体显性遗传", "伴 X 隐性遗传", "伴 X 显性遗传"],
            answerIndex: 0,
            verdict: "无中生有为隐性；女儿患病而父亲正常，排除伴 X 隐性 → 常染色体隐性遗传。口诀：“隐性看女病，女病父正非伴性”。"),

        PedigreeCase(
            id: "pd_x_rec", title: "只在男丁里现身",
            scenario: "某家族一种病，调查发现：患者几乎都是男性；一位正常女性的父亲和儿子都患病。判断遗传方式。",
            clues: [
                PedigreeClue(id: "c1", text: "存在正常父母生出患病儿子的情况。",
                             deduction: "无中生有 → 隐性遗传。"),
                PedigreeClue(id: "c2", text: "患者绝大多数是男性，女性患者极少。",
                             deduction: "男性患者远多于女性 → 提示致病基因很可能在 X 染色体上（男性只要一个 Xᵃ 就患病）。"),
                PedigreeClue(id: "c3", text: "一位表现正常的女性，其父亲和儿子都患病。",
                             deduction: "她父亲患病(XᵃY)必传 Xᵃ 给她，她又把 Xᵃ 传给患病儿子——交叉遗传，符合伴 X 隐性。"),
            ],
            options: ["伴 X 隐性遗传", "常染色体隐性遗传", "伴 X 显性遗传", "伴 Y 遗传"],
            answerIndex: 0,
            verdict: "隐性 + 男性患者远多于女性 + 外祖父→母亲（携带）→外孙的交叉遗传 → 伴 X 隐性遗传。"),
    ]
}
