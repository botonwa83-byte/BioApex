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

        ChallengeProblem(
            id: "ch_prob", title: "两病独立 · 只患一种的概率", kind: .gaokao, weapon: .probability,
            topic: "遗传", difficulty: 4,
            content: "甲病（基因 A/a，aa 患病）、乙病（基因 B/b，bb 患病）独立遗传。一对均为 AaBb 的夫妇，所生孩子「只患一种病」的概率是多少？",
            trap: "「只患一种」既不是「患病」也不是「至少一种」，直接乘除最易混、漏项。",
            keyInsight: "拆成互斥两类相加：只患甲 = 患甲×不患乙；只患乙 = 不患甲×患乙。",
            steps: ["患甲 aa = 1/4，不患甲 = 3/4；患乙 bb = 1/4，不患乙 = 3/4",
                    "只患甲 = 1/4 × 3/4 = 3/16",
                    "只患乙 = 3/4 × 1/4 = 3/16",
                    "只患一种 = 3/16 + 3/16 = 6/16 = 3/8"],
            answer: "3/8。",
            takeaway: "概率拆解：「只患一种」拆成两个互斥事件相加；「至少患一种」= 1 − 都不患；「都患」直接相乘。看清关键词再下手。"),

        ChallengeProblem(
            id: "ch_graph", title: "曲线到了平台，怎么再上去", kind: .gaokao, weapon: .graphReading,
            topic: "代谢", difficulty: 3,
            content: "某植物光合速率随光照强度增强而上升，超过某一光照强度后曲线变平（不再上升）。此时限制光合速率的主要因素是什么？怎样进一步提高？",
            trap: "看到平台就以为「到顶了」，答不出该换哪个因素。",
            keyInsight: "平台段说明光照已不再是限制因素，要找「此时」的限制因素——CO₂ 浓度或温度。",
            steps: ["上升段：光照强度是限制因素",
                    "平台段（光饱和点之后）：再增光无效 → 光不再是限制因素",
                    "此时限制因素是 CO₂ 浓度（或温度）",
                    "适当增施 CO₂ 或调到最适温度，曲线可继续上升"],
            answer: "限制因素是 CO₂ 浓度（或温度）；增施 CO₂、调至最适温度可进一步提高。",
            takeaway: "坐标曲线三看：看轴 → 看拐点/平台 → 判限制因素。平台段必须换「非横轴」的因素才能突破。"),

        ChallengeProblem(
            id: "ch_control", title: "验证甲状腺激素促发育", kind: .gaokao, weapon: .control,
            topic: "稳态", difficulty: 3,
            content: "请设计实验思路，验证「甲状腺激素能促进蝌蚪的发育」。（写出自变量、对照设置与预期结果）",
            trap: "不设对照、或同时改变多个条件，结论就不可信。",
            keyInsight: "单一变量：实验组加甲状腺激素，对照组等量不加，其余条件相同且适宜。",
            steps: ["取发育状况相同的蝌蚪，随机均分为两组",
                    "实验组投喂含适量甲状腺激素的饲料；对照组投喂等量、不含激素的相同饲料",
                    "其他条件（水温、水量、食物量等）相同且适宜",
                    "一段时间后比较两组发育速度（如长出四肢、变态时间）"],
            answer: "预期实验组发育明显快于对照组，即可验证结论。",
            takeaway: "实验设计三原则：单一变量 + 对照 + 等量适宜。「验证类」预期唯一；「探究类」要列出多种可能结果。"),

        ChallengeProblem(
            id: "ch_reverse", title: "由 3∶1 反推亲本基因型", kind: .gaokao, weapon: .reverse,
            topic: "遗传", difficulty: 2,
            content: "两株高茎豌豆杂交，后代出现高茎∶矮茎 = 3∶1（高茎 D 对矮茎 d 为显性）。推断两亲本的基因型。",
            trap: "看到亲本都是高茎，就草率写成 DD，忽略了后代里的矮茎。",
            keyInsight: "后代出现矮茎（dd），说明双亲都含有 d；而双亲都是高茎，只能是 Dd。",
            steps: ["后代出现矮茎 dd → 双亲都带有 d 基因",
                    "双亲表现高茎（D_）→ 基因型只能是 Dd",
                    "验证：Dd × Dd → 3 高∶1 矮，吻合"],
            answer: "两亲本基因型均为 Dd。",
            takeaway: "由子代分离比逆推亲本：3∶1 ⇐ Dd×Dd；1∶1 ⇐ Dd×dd；全显 ⇐ 至少一方为 DD。先看子代再回推。"),

        ChallengeProblem(
            id: "ch_gamete", title: "配子法破多对基因杂交", kind: .gaokao, weapon: .gamete,
            topic: "遗传", difficulty: 3,
            content: "基因型 AaBb 的个体与 aabb 个体杂交（两对基因独立遗传），求后代的表现型种类及比例。",
            trap: "亲本不是 AaBb×AaBb，套用 9∶3∶3∶1 就错了；硬画棋盘又慢。",
            keyInsight: "配子法：先写出每个亲本产生的配子种类与比例，再两两组合。",
            steps: ["AaBb 产生 4 种等比配子：AB、Ab、aB、ab，各 1/4",
                    "aabb 只产生 1 种配子：ab",
                    "组合得后代：AaBb、Aabb、aaBb、aabb，各占 1/4",
                    "表现型 A_B_∶A_bb∶aaB_∶aabb = 1∶1∶1∶1"],
            answer: "4 种表现型，比例 1∶1∶1∶1。",
            takeaway: "配子法通用：先定各亲本的配子种类与比例，再组合相乘——尤其适合亲本基因型不对称（非自交）的杂交。"),

        ChallengeProblem(
            id: "ch_pedigree", title: "系谱三步：判方式 + 算概率", kind: .gaokao, weapon: .pedigree,
            topic: "遗传", difficulty: 4,
            content: "一对表现都正常的夫妇，生了一个患某单基因遗传病的女儿。判断该病的遗传方式，并求这对夫妇再生一个患病男孩的概率。",
            trap: "易停在“隐性”，不会进一步定常/X，也容易忘记“男孩”要再乘 1/2。",
            keyInsight: "三步走：①无中生有定隐性；②患病女儿+父亲正常 → 排除伴 X 隐 → 常隐；③双亲 Aa，按概率算。",
            steps: ["第一步 判显隐：正常×正常 → 患病女儿，“无中生有” → 隐性遗传",
                    "第二步 定常/X：若伴 X 隐，患病女儿 XᵃXᵃ 要求父亲 XᵃY（应患病）；父亲正常 → 排除 → 常染色体隐性",
                    "第三步 算概率：双亲均为 Aa；再生孩子患病 aa = 1/4",
                    "患病男孩 = 患病 1/4 × 男孩 1/2 = 1/8"],
            answer: "常染色体隐性遗传；再生患病男孩的概率为 1/8。",
            takeaway: "系谱判定三步法：判显隐（无中生有/有中生无）→ 定常/X（女病看父、男病看母）→ 按基因型算概率；问“患病男孩”别忘再乘性别 1/2。"),

        ChallengeProblem(
            id: "ch_scoring", title: "光合“午休”——简答怎么踩满分", kind: .gaokao, weapon: .scoring,
            topic: "代谢", difficulty: 3,
            content: "夏季晴天的正午，许多植物的光合作用速率会出现短暂下降（光合“午休”现象）。请规范解释其主要原因。",
            trap: "口语化、只答“温度太高”，踩不到采分点，大题白白丢分。",
            keyInsight: "按“因果链 + 术语”逐点答：强光高温 → 蒸腾失水 → 气孔（部分）关闭 → CO₂ 供应减少 → 暗反应减弱 → 光合下降。",
            steps: ["先锁定核心机制：气孔关闭导致 CO₂ 供应不足",
                    "拆成因果链分层：光照强、温度高 → 蒸腾过强失水 → 气孔部分关闭 → 胞间 CO₂ 减少 → 暗反应（CO₂ 固定）减弱 → 光合速率下降",
                    "逐点用规范术语：“气孔关闭”“CO₂ 供应减少”“暗反应/CO₂ 固定减弱”都是采分点",
                    "因果完整、不漏关键词，分点表述"],
            answer: "正午光照过强、温度过高，蒸腾作用过强使植物失水，导致气孔部分关闭，进入叶片的 CO₂ 减少，暗反应中 CO₂ 的固定减弱，从而光合作用速率短暂下降。",
            takeaway: "采分点表述：先理清因果链（原因→机制→结果），每个环节用规范术语单独成点；简答题“踩点给分”，关键节点宁多勿漏。"),
    ]

    static func problem(id: String) -> ChallengeProblem? { all.first { $0.id == id } }
}
