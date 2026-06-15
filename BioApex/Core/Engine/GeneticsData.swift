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
    ] + [
        GeneticsCase(
            id: "gd_lethal", title: "显性纯合致死 · 自交后代比",
            content: "某种植物中，显性纯合子（AA）在胚胎期死亡。让杂合子 Aa 自交，成活后代中显性（Aa）与隐性（aa）的比例是？",
            options: ["2 : 1", "3 : 1", "1 : 1", "1 : 2"],
            answerIndex: 0,
            explanation: "Aa×Aa→1AA:2Aa:1aa。AA 致死，成活的只有 2Aa:1aa，即显:隐=2:1。",
            duo: DuoSolution(
                standard: SolvePath(title: "常规解：先写全比例再剔除", steps: [
                    "Aa×Aa 后代 1AA : 2Aa : 1aa",
                    "AA 胚胎致死，从分母里去掉这 1 份",
                    "剩下 2Aa : 1aa",
                    "显:隐 = 2:1",
                ], minutes: 1.5),
                shortcut: SolvePath(title: "秒算：剔除致死项重新归一", steps: [
                    "正常 1:2:1，划掉致死的 AA（1 份）",
                    "剩 2:1，直接读出 ✓",
                ], minutes: 0.3),
                principle: "原理：致死会改变我们观察到的比例，因为死掉的个体不计入「成活后代」这个分母。只要先按正常分离定律写出 1:2:1，再把致死的那一类划掉、对剩下的重新看比例即可。本质还是分离定律，只是统计范围被致死筛掉了一部分。",
                keyInsight: "有致死先按正常比例写全，划掉致死项，对剩余重新归一。",
                plainTalk: "本来是 1 份 AA、2 份 Aa、1 份 aa。AA 还没出生就没了，能数的就剩 2 份 Aa 和 1 份 aa，比例自然是 2 比 1。别忘了把死掉的从总数里也去掉。")),

        GeneticsCase(
            id: "gd_twodisease", title: "两病独立 · 至少患一种的概率",
            content: "甲病(基因 A/a)、乙病(基因 B/b)独立遗传，aa 患甲、bb 患乙。双亲均为 AaBb，后代「至少患一种病」的概率是？",
            options: ["7/16", "9/16", "1/16", "3/16"],
            answerIndex: 0,
            explanation: "患甲 aa=1/4，患乙 bb=1/4。都不患 = 3/4×3/4 = 9/16；至少患一种 = 1−9/16 = 7/16。",
            duo: DuoSolution(
                standard: SolvePath(title: "常规解：分类相加", steps: [
                    "只患甲 = 1/4×3/4 = 3/16",
                    "只患乙 = 3/4×1/4 = 3/16",
                    "同时患两病 = 1/4×1/4 = 1/16",
                    "相加 3/16+3/16+1/16 = 7/16（易漏项）",
                ], minutes: 3),
                shortcut: SolvePath(title: "秒算：用对立事件「都不患」", steps: [
                    "都不患 = 正常×正常 = 3/4×3/4 = 9/16",
                    "至少患一种 = 1 − 9/16 = 7/16 ✓",
                ], minutes: 0.5),
                principle: "原理：「至少患一种」包含三种情况，正面分类相加既慢又容易漏。它的对立面只有一种——「两种都不患」，算起来干净利落。用 1 减去对立事件的概率，是概率题里最常用的提速技巧。看到「至少」二字，先想反面。",
                keyInsight: "见「至少患一种」立刻转成 1 −「都不患」。",
                plainTalk: "正着数要把只得甲、只得乙、两种都得加起来，麻烦还漏项。反过来想：两种病都躲过去的概率是 9/16，拿 1 一减就是 7/16。「至少」就用减法。")),

        GeneticsCase(
            id: "gd_selfing_n", title: "连续自交 n 代 · 纯合子比例",
            content: "基因型 Aa 的植物连续自交 3 代（自交 3 次），后代中纯合子所占的比例是？",
            options: ["7/8", "1/8", "1/2", "3/4"],
            answerIndex: 0,
            explanation: "自交 n 代后杂合子 Aa = (1/2)ⁿ，纯合子 = 1−(1/2)ⁿ。n=3：杂合 1/8，纯合 7/8。",
            duo: DuoSolution(
                standard: SolvePath(title: "常规解：逐代往下推", steps: [
                    "第 1 代：1/2 是 Aa",
                    "第 2 代：1/4 是 Aa",
                    "第 3 代：1/8 是 Aa（每代杂合减半）",
                    "纯合 = 1 − 1/8 = 7/8",
                ], minutes: 2),
                shortcut: SolvePath(title: "秒算：套公式 1−(1/2)ⁿ", steps: [
                    "杂合子每自交一代减半 → (1/2)ⁿ",
                    "n=3 → 杂合 1/8，纯合 1−1/8 = 7/8 ✓",
                ], minutes: 0.3),
                principle: "原理：杂合子 Aa 自交，后代里 1/2 仍是杂合、另一半变成纯合(AA、aa)。所以每自交一代，杂合子比例就减半，n 代后是 (1/2)ⁿ，纯合子是剩下的 1−(1/2)ⁿ。记住公式，再多代也不用一代代画。",
                keyInsight: "自交 n 代：杂合子 (1/2)ⁿ，纯合子 1−(1/2)ⁿ。",
                plainTalk: "杂合子每自交一次，就有一半「转正」成纯合子。自交三次，杂合子从一整份变成八分之一，剩下八分之七全是纯合子。公式记牢，不用慢慢画。")),

        GeneticsCase(
            id: "gd_kinds", title: "多对杂合 · 配子与后代种类",
            content: "基因型 AaBbCc 的个体（三对基因独立遗传）自交，它产生的配子种类数、自交后代的基因型种类数分别是？",
            options: ["8 种、27 种", "6 种、9 种", "8 种、9 种", "4 种、27 种"],
            answerIndex: 0,
            explanation: "n 对杂合：配子 2ⁿ 种；自交后代基因型 3ⁿ 种、表现型 2ⁿ 种。n=3：配子 2³=8，基因型 3³=27。",
            duo: DuoSolution(
                standard: SolvePath(title: "常规解：逐对列举再相乘", steps: [
                    "配子：每对杂合出 2 种，3 对 → 2×2×2",
                    "基因型：每对自交出 3 种（如 Aa→AA/Aa/aa），3 对 → 3×3×3",
                    "配子 8 种、基因型 27 种",
                ], minutes: 2),
                shortcut: SolvePath(title: "秒算：套 2ⁿ / 3ⁿ", steps: [
                    "n=3 对杂合 → 配子 2³ = 8 种",
                    "自交后代基因型 3³ = 27 种、表现型 2³ = 8 种 ✓",
                ], minutes: 0.3),
                principle: "原理：各对基因独立，总种类数就是每一对种类数的乘积（乘法原理）。一对杂合产生 2 种配子、自交产生 3 种基因型，于是 n 对就是 2ⁿ 和 3ⁿ。先数清「有几对是杂合的」，公式直接套。",
                keyInsight: "数清杂合的对数 n：配子 2ⁿ、自交基因型 3ⁿ、表现型 2ⁿ。",
                plainTalk: "三对基因互不干扰，把每对的花样乘起来就行。配子每对 2 种，三对就是 2×2×2=8；自交每对 3 种基因型，三对就是 3×3×3=27。关键先看有几对是 Aa 这样的杂合。")),
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

        PedigreeCase(
            id: "pd_auto_dom", title: "代代相传的怪症",
            scenario: "某遗传病在一个家族中几乎每一代都有患者；一对患病的夫妇却生了一个完全正常的女儿。请判断遗传方式。",
            clues: [
                PedigreeClue(id: "c1", text: "患病的双亲生出了不患病的孩子。",
                             deduction: "“有中生无”——双亲患病、孩子正常，说明患病是显性性状（正常为隐性）。"),
                PedigreeClue(id: "c2", text: "家族中几乎每一代都有患者，不隔代。",
                             deduction: "连续遗传、不隔代，符合显性遗传的特征。"),
                PedigreeClue(id: "c3", text: "那个正常孩子是女儿，其父亲患病。",
                             deduction: "若为伴 X 显性，患病父亲(XᴬY)必把 Xᴬ 传给所有女儿，女儿都应患病；但女儿正常，故排除伴 X 显性 → 基因在常染色体上。"),
            ],
            options: ["常染色体显性遗传", "常染色体隐性遗传", "伴 X 显性遗传", "伴 X 隐性遗传"],
            answerIndex: 0,
            verdict: "有中生无为显性；患病父亲却有正常女儿，排除伴 X 显性 → 常染色体显性遗传。口诀：“显性看男病，父病女正非伴性”。"),

        PedigreeCase(
            id: "pd_x_dom", title: "传女更勤的病",
            scenario: "某病调查显示：女性患者明显多于男性；每个患病男性的母亲和女儿都患病。判断遗传方式。",
            clues: [
                PedigreeClue(id: "c1", text: "存在患病双亲生出正常孩子的情况。",
                             deduction: "有中生无 → 显性遗传（正常为隐性）。"),
                PedigreeClue(id: "c2", text: "女性患者明显多于男性患者。",
                             deduction: "女患＞男患 → 提示致病基因在 X 上且为显性（女性有两条 X，获得显性致病基因的机会更大）。"),
                PedigreeClue(id: "c3", text: "每个患病男性(XᴬY)的母亲和女儿都患病。",
                             deduction: "患病男性的 Xᴬ 必来自母亲、又必传给所有女儿——“父病女必病、子病母必病”，正是伴 X 显性的标志。"),
            ],
            options: ["伴 X 显性遗传", "常染色体显性遗传", "伴 X 隐性遗传", "常染色体隐性遗传"],
            answerIndex: 0,
            verdict: "显性 + 女患多于男患 + 父病则女必病、子病则母必病 → 伴 X 显性遗传（如抗维生素 D 佝偻病）。"),

        PedigreeCase(
            id: "pd_uncertain", title: "证据不足的悬案",
            scenario: "一对表现正常的夫妇生了一个患病的儿子，家族中再无其他患者。仅凭此能否确定是常染色体隐性还是伴 X 隐性？",
            clues: [
                PedigreeClue(id: "c1", text: "表现正常的父母生出患病儿子。",
                             deduction: "无中生有 → 可以确定是隐性遗传。"),
                PedigreeClue(id: "c2", text: "患者是儿子（男性）。",
                             deduction: "男性患病：若常隐则为 aa，若伴 X 隐则为 XᵃY——两种情况都允许母亲是携带者、父亲正常，都说得通。"),
                PedigreeClue(id: "c3", text: "系谱中没有患病的女性。",
                             deduction: "区分常隐与伴 X 隐的关键证据是“患病女儿的父亲是否患病”；本系谱无患病女性，无法排除任何一种。"),
            ],
            options: ["只能确定是隐性，无法区分常隐与伴 X 隐", "一定是常染色体隐性", "一定是伴 X 隐性", "一定是显性遗传"],
            answerIndex: 0,
            verdict: "无中生有确定隐性；但男性患者在常隐、伴 X 隐下都成立，缺少患病女性这一关键证据，故只能判定隐性、无法确定基因位置。提醒：判定伴性的钥匙常在“患病女性及其父亲/儿子”身上。"),
    ]
}
