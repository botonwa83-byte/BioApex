import Foundation

// MARK: - 过程剧场数据（生物闪光点）
// 前 4 个免费（光合/呼吸/有丝分裂/渗透），减数分裂与翻译需解锁。
// 红线：场所、物质、顺序必须科学准确。

enum ProcessData {
    static let all: [ProcessScene] = [
        photosynthesis, respiration, mitosis, osmosis, meiosis, translation,
        nerveImpulse, secretion, humoralImmunity,
    ]

    static func scene(id: String) -> ProcessScene? { all.first { $0.id == id } }

    // MARK: 光合作用
    private static let photosynthesis = ProcessScene(
        id: "ps_photosynthesis", title: "光合作用", subtitle: "光能 → 有机物中的化学能",
        module: .molecule, location: "叶绿体（类囊体薄膜 + 基质）",
        examHook: "光反应为暗反应供 [H] 和 ATP；停光后 C₃ 升、C₅ 降。",
        stages: [
            ProcessStage(id: "p1", name: "光反应 · 水的光解", detail: "类囊体薄膜上，色素吸收光能，水被光解。",
                         consumes: "H₂O、光能", produces: "[H]、O₂",
                         quiz: ProcessQuiz(prompt: "水的光解发生在？", options: ["类囊体薄膜", "叶绿体基质", "线粒体内膜"], answerIndex: 0, explanation: "光反应在类囊体薄膜上，需色素和光。")),
            ProcessStage(id: "p2", name: "光反应 · ATP 生成", detail: "光能驱动 ADP 与 Pi 合成 ATP。",
                         consumes: "ADP、Pi、光能", produces: "ATP"),
            ProcessStage(id: "p3", name: "暗反应 · CO₂ 固定", detail: "叶绿体基质中，CO₂ 与 C₅ 结合生成 C₃。",
                         consumes: "CO₂、C₅", produces: "C₃",
                         quiz: ProcessQuiz(prompt: "突然停止光照，短时间内 C₃ 含量会？", options: ["升高", "降低", "不变"], answerIndex: 0, explanation: "停光→[H]和ATP减少→C₃还原受阻而积累，C₃升、C₅降。")),
            ProcessStage(id: "p4", name: "暗反应 · C₃ 还原", detail: "C₃ 在 ATP 和 [H] 作用下被还原为有机物，并再生 C₅。",
                         consumes: "ATP、[H]、C₃", produces: "有机物(糖)、C₅"),
        ])

    // MARK: 有氧呼吸
    private static let respiration = ProcessScene(
        id: "ps_respiration", title: "有氧呼吸", subtitle: "有机物 → 大量能量(ATP)",
        module: .molecule, location: "细胞质基质 + 线粒体",
        examHook: "三阶段产物与场所是高频考点；水在第三阶段生成，需 O₂。",
        stages: [
            ProcessStage(id: "r1", name: "第一阶段 · 糖酵解", detail: "细胞质基质中，葡萄糖分解为丙酮酸。",
                         consumes: "葡萄糖", produces: "丙酮酸、[H]、少量ATP",
                         quiz: ProcessQuiz(prompt: "第一阶段发生在？", options: ["细胞质基质", "线粒体基质", "线粒体内膜"], answerIndex: 0, explanation: "糖酵解在细胞质基质，是有氧无氧呼吸共有的第一阶段。")),
            ProcessStage(id: "r2", name: "第二阶段 · 丙酮酸分解", detail: "线粒体基质中，丙酮酸与水反应生成 CO₂ 和 [H]。",
                         consumes: "丙酮酸、H₂O", produces: "CO₂、[H]、少量ATP"),
            ProcessStage(id: "r3", name: "第三阶段 · 电子传递", detail: "线粒体内膜上，[H] 与 O₂ 结合生成水，释放大量能量。",
                         consumes: "[H]、O₂", produces: "H₂O、大量ATP",
                         quiz: ProcessQuiz(prompt: "有氧呼吸生成水的阶段消耗的是？", options: ["O₂ 和 [H]", "葡萄糖", "CO₂"], answerIndex: 0, explanation: "第三阶段 [H]+O₂→H₂O，释放绝大部分能量。")),
        ])

    // MARK: 有丝分裂
    private static let mitosis = ProcessScene(
        id: "ps_mitosis", title: "有丝分裂", subtitle: "一个细胞 → 两个相同的子细胞",
        module: .molecule, location: "体细胞",
        examHook: "“前期两消失、中期排中央、后期点裂开、末期两重现”；DNA间期加倍。",
        stages: [
            ProcessStage(id: "t1", name: "间期", detail: "DNA 复制和有关蛋白质合成，染色体数不变、DNA加倍。",
                         consumes: "原料、ATP", produces: "复制后的DNA"),
            ProcessStage(id: "t2", name: "前期", detail: "染色质变为染色体，核膜核仁消失，出现纺锤体。",
                         quiz: ProcessQuiz(prompt: "前期的标志性变化是？", options: ["核膜核仁消失、出现纺锤体", "着丝点分裂", "染色体排在赤道板"], answerIndex: 0, explanation: "“两消失、两出现”是前期特征。")),
            ProcessStage(id: "t3", name: "中期", detail: "着丝点整齐排列在赤道板上，是观察染色体形态数目的最佳时期。",
                         produces: "染色体清晰可数"),
            ProcessStage(id: "t4", name: "后期", detail: "着丝点分裂，姐妹染色单体分开移向两极，染色体数目暂时加倍。",
                         quiz: ProcessQuiz(prompt: "后期染色体数目暂时加倍的原因是？", options: ["着丝点分裂", "DNA复制", "核膜消失"], answerIndex: 0, explanation: "着丝点分裂使姐妹染色单体成为独立染色体，数目暂时加倍。")),
            ProcessStage(id: "t5", name: "末期", detail: "染色体变回染色质，核膜核仁重现，细胞质分裂为两个子细胞。",
                         produces: "两个子细胞"),
        ])

    // MARK: 渗透与质壁分离（免费）
    private static let osmosis = ProcessScene(
        id: "ps_osmosis", title: "质壁分离与复原", subtitle: "成熟植物细胞的渗透作用",
        module: .molecule, location: "成熟植物细胞",
        examHook: "可判断细胞死活、比较细胞液浓度；原生质层相当于半透膜。",
        stages: [
            ProcessStage(id: "o1", name: "正常状态", detail: "细胞液与外界浓度相近，细胞处于动态平衡。"),
            ProcessStage(id: "o2", name: "质壁分离", detail: "外界溶液浓度大于细胞液，细胞失水，原生质层与细胞壁分离。",
                         consumes: "细胞内水分",
                         quiz: ProcessQuiz(prompt: "发生质壁分离说明外界溶液浓度？", options: ["大于细胞液浓度", "小于细胞液浓度", "等于细胞液浓度"], answerIndex: 0, explanation: "外界浓度更高→细胞渗透失水→质壁分离。")),
            ProcessStage(id: "o3", name: "质壁分离复原", detail: "换成清水后细胞吸水，原生质层复原，说明细胞是活的。",
                         produces: "复原（细胞存活）"),
        ])

    // MARK: 减数分裂（付费）
    private static let meiosis = ProcessScene(
        id: "ps_meiosis", title: "减数分裂", subtitle: "染色体减半，产生配子",
        module: .genetics, location: "原始生殖细胞",
        examHook: "同源染色体分开在减Ⅰ后期；染色体数目减半发生在减Ⅰ末。",
        stages: [
            ProcessStage(id: "me1", name: "减Ⅰ前期 · 联会", detail: "同源染色体两两配对（联会）形成四分体，可发生交叉互换。",
                         produces: "四分体"),
            ProcessStage(id: "me2", name: "减Ⅰ后期", detail: "同源染色体分开、非同源染色体自由组合，移向两极。",
                         quiz: ProcessQuiz(prompt: "同源染色体分开发生在？", options: ["减Ⅰ后期", "减Ⅱ后期", "有丝分裂后期"], answerIndex: 0, explanation: "减Ⅰ后期同源染色体分开，使染色体数目减半。")),
            ProcessStage(id: "me3", name: "减Ⅰ末期", detail: "形成 2 个次级性母细胞，染色体数目已减半（仍含姐妹染色单体）。",
                         produces: "次级性母细胞(n)"),
            ProcessStage(id: "me4", name: "减Ⅱ后期", detail: "着丝点分裂，姐妹染色单体分开，类似有丝分裂。",
                         quiz: ProcessQuiz(prompt: "姐妹染色单体分开发生在？", options: ["减Ⅱ后期", "减Ⅰ后期", "减Ⅰ前期"], answerIndex: 0, explanation: "减Ⅱ后期着丝点分裂，姐妹染色单体分开。")),
            ProcessStage(id: "me5", name: "形成配子", detail: "最终形成 4 个染色体数目减半的配子。",
                         produces: "4 个配子(n)"),
        ])

    // MARK: 转录与翻译（付费）
    private static let translation = ProcessScene(
        id: "ps_translation", title: "转录与翻译", subtitle: "基因 → 蛋白质（中心法则）",
        module: .genetics, location: "细胞核 + 核糖体",
        examHook: "转录在核内、模板是DNA一条链；翻译在核糖体、密码子在mRNA上。",
        stages: [
            ProcessStage(id: "tr1", name: "转录", detail: "在细胞核中以 DNA 一条链为模板，按碱基互补配对合成 mRNA（A配U）。",
                         consumes: "DNA模板、核糖核苷酸", produces: "mRNA",
                         quiz: ProcessQuiz(prompt: "转录的模板和产物分别是？", options: ["DNA一条链 → mRNA", "mRNA → 蛋白质", "DNA双链 → DNA"], answerIndex: 0, explanation: "转录以DNA一条链为模板合成mRNA，发生在细胞核。")),
            ProcessStage(id: "tr2", name: "mRNA 运出", detail: "mRNA 通过核孔进入细胞质，与核糖体结合。",
                         produces: "mRNA-核糖体复合体"),
            ProcessStage(id: "tr3", name: "翻译", detail: "核糖体沿 mRNA 移动，tRNA 按密码子搬运氨基酸，脱水缩合成肽链。",
                         consumes: "mRNA、tRNA、氨基酸", produces: "蛋白质(肽链)",
                         quiz: ProcessQuiz(prompt: "决定氨基酸的密码子位于？", options: ["mRNA上", "tRNA上", "DNA上"], answerIndex: 0, explanation: "密码子在mRNA上，每3个碱基决定一个氨基酸；tRNA上是反密码子。")),
        ])

    // MARK: 兴奋的产生与传导（付费）
    private static let nerveImpulse = ProcessScene(
        id: "ps_nerve", title: "兴奋的产生与传导", subtitle: "静息电位 → 动作电位 → 突触传递",
        module: .homeostasis, location: "神经纤维 + 突触",
        examHook: "静息电位由 K⁺ 外流维持；动作电位由 Na⁺ 内流形成；兴奋在突触处只能单向传递。",
        stages: [
            ProcessStage(id: "n1", name: "静息电位", detail: "未受刺激时，K⁺ 外流，膜电位表现为外正内负。",
                         produces: "外正内负的静息电位",
                         quiz: ProcessQuiz(prompt: "静息电位主要由哪种离子外流维持？", options: ["K⁺", "Na⁺", "Ca²⁺"], answerIndex: 0, explanation: "静息时 K⁺ 外流，使膜电位外正内负。")),
            ProcessStage(id: "n2", name: "动作电位", detail: "受刺激处 Na⁺ 内流，该处膜电位变为外负内正（兴奋）。",
                         consumes: "适宜刺激", produces: "外负内正的动作电位",
                         quiz: ProcessQuiz(prompt: "兴奋时膜变为外负内正，原因是？", options: ["Na⁺ 内流", "K⁺ 外流", "Cl⁻ 内流"], answerIndex: 0, explanation: "受刺激时 Na⁺ 内流，形成动作电位。")),
            ProcessStage(id: "n3", name: "兴奋在纤维上传导", detail: "兴奋部位与未兴奋部位间形成局部电流，使兴奋沿神经纤维双向传导。",
                         produces: "局部电流（神经冲动）"),
            ProcessStage(id: "n4", name: "突触传递", detail: "兴奋传到突触前膜，突触小泡释放神经递质，经突触间隙作用于突触后膜受体。",
                         consumes: "神经递质、ATP", produces: "突触后膜电位变化",
                         quiz: ProcessQuiz(prompt: "兴奋在突触处的传递方向是？", options: ["只能单向（前膜→后膜）", "可以双向", "无方向"], answerIndex: 0, explanation: "递质只能由突触前膜释放、作用于后膜，故只能单向传递。")),
        ])

    // MARK: 分泌蛋白的合成与运输（付费）
    private static let secretion = ProcessScene(
        id: "ps_secretion", title: "分泌蛋白的合成与运输", subtitle: "核糖体 → 内质网 → 高尔基体 → 细胞膜",
        module: .molecule, location: "多种细胞器协作（生物膜系统）",
        examHook: "分泌蛋白经核糖体→内质网→高尔基体→细胞膜；线粒体全程供能、膜间靠囊泡运输。",
        stages: [
            ProcessStage(id: "se1", name: "核糖体合成肽链", detail: "核糖体以氨基酸为原料，脱水缩合合成肽链。",
                         consumes: "氨基酸", produces: "肽链",
                         quiz: ProcessQuiz(prompt: "分泌蛋白合成肽链的场所是？", options: ["核糖体", "内质网", "高尔基体"], answerIndex: 0, explanation: "蛋白质（肽链）在核糖体上合成。")),
            ProcessStage(id: "se2", name: "内质网加工", detail: "肽链进入内质网初步折叠加工，由囊泡包裹运向高尔基体。",
                         consumes: "肽链", produces: "囊泡（内含初步加工的蛋白）"),
            ProcessStage(id: "se3", name: "高尔基体加工分类", detail: "高尔基体进一步加工、分类、包装，形成成熟的分泌小泡。",
                         produces: "成熟分泌蛋白（分泌小泡）"),
            ProcessStage(id: "se4", name: "胞吐分泌出细胞", detail: "分泌小泡与细胞膜融合，以胞吐方式排出细胞外，线粒体全程供能。",
                         consumes: "ATP（线粒体供能）", produces: "分泌到细胞外的蛋白",
                         quiz: ProcessQuiz(prompt: "整个过程提供能量的细胞器是？", options: ["线粒体", "核糖体", "高尔基体"], answerIndex: 0, explanation: "线粒体通过有氧呼吸为合成、加工、运输和分泌提供能量。")),
        ])

    // MARK: 体液免疫（付费）
    private static let humoralImmunity = ProcessScene(
        id: "ps_humoral", title: "体液免疫", subtitle: "B 细胞 → 浆细胞 → 抗体",
        module: .homeostasis, location: "内环境（血液、淋巴）",
        examHook: "浆细胞产生抗体清除细胞外病原体；记忆细胞使二次免疫更快更强。",
        stages: [
            ProcessStage(id: "hi1", name: "抗原识别与呈递", detail: "病原体入侵，被吞噬细胞摄取处理，把抗原呈递给辅助性 T 细胞。",
                         consumes: "抗原", produces: "被呈递的抗原信息"),
            ProcessStage(id: "hi2", name: "B 细胞活化增殖", detail: "在抗原刺激和辅助性 T 细胞的作用下，B 细胞增殖、分化。",
                         produces: "浆细胞和记忆 B 细胞",
                         quiz: ProcessQuiz(prompt: "B 细胞增殖分化形成的是？", options: ["浆细胞和记忆细胞", "细胞毒性 T 细胞", "吞噬细胞"], answerIndex: 0, explanation: "B 细胞增殖分化为浆细胞（产生抗体）和记忆 B 细胞。")),
            ProcessStage(id: "hi3", name: "浆细胞分泌抗体", detail: "浆细胞（效应 B 细胞）大量合成并分泌特异性抗体。",
                         produces: "抗体",
                         quiz: ProcessQuiz(prompt: "能产生抗体的细胞是？", options: ["浆细胞", "记忆细胞", "辅助性 T 细胞"], answerIndex: 0, explanation: "抗体由浆细胞产生；浆细胞自身不能识别抗原。")),
            ProcessStage(id: "hi4", name: "抗体清除抗原", detail: "抗体与相应抗原特异性结合，使其失活或聚集，再被吞噬细胞清除；记忆细胞长期留存。",
                         produces: "抗原被清除 + 记忆细胞",
                         quiz: ProcessQuiz(prompt: "同种抗原再次入侵时反应更快更强，靠的是？", options: ["记忆细胞迅速增殖分化", "皮肤黏膜屏障", "吞噬细胞增多"], answerIndex: 0, explanation: "记忆细胞遇相同抗原能迅速增殖分化，产生大量抗体，使二次免疫更快更强。")),
        ])
}
