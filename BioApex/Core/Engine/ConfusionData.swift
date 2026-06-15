import Foundation

// MARK: - 易混辨析数据（生物易混点全科第一，本模块是杀手锏）
// 红线：对比内容必须准确。

enum ConfusionData {
    static let all: [ConfusionPair] = [
        ConfusionPair(
            id: "cf_mitosis_meiosis", title: "有丝分裂 vs 减数分裂",
            leftName: "有丝分裂", rightName: "减数分裂",
            rows: [
                ConfusionRow(dimension: "发生部位", left: "体细胞", right: "原始生殖细胞"),
                ConfusionRow(dimension: "分裂次数", left: "一次", right: "连续两次"),
                ConfusionRow(dimension: "同源染色体行为", left: "不联会、不分开", right: "联会形成四分体，减Ⅰ后期分开"),
                ConfusionRow(dimension: "子细胞数目", left: "2 个", right: "4 个（配子）"),
                ConfusionRow(dimension: "染色体数变化", left: "不变（与母细胞相同）", right: "减半"),
            ],
            quizzes: [
                ConfusionQuiz(id: "q1", statement: "出现联会、四分体现象。", answerIsLeft: false,
                              explanation: "联会、四分体是减数分裂特有，有丝分裂无同源染色体配对。"),
                ConfusionQuiz(id: "q2", statement: "子细胞染色体数与母细胞相同。", answerIsLeft: true,
                              explanation: "有丝分裂保持染色体数不变；减数分裂子细胞染色体减半。"),
                ConfusionQuiz(id: "q3", statement: "一个细胞最终产生 4 个子细胞。", answerIsLeft: false,
                              explanation: "减数分裂经两次分裂产生 4 个配子；有丝分裂产生 2 个。"),
            ]),
        ConfusionPair(
            id: "cf_active_facilitated", title: "主动运输 vs 协助扩散",
            leftName: "主动运输", rightName: "协助扩散",
            rows: [
                ConfusionRow(dimension: "运输方向", left: "可逆浓度梯度", right: "顺浓度梯度"),
                ConfusionRow(dimension: "是否需载体", left: "需要", right: "需要"),
                ConfusionRow(dimension: "是否耗能", left: "消耗 ATP", right: "不耗能"),
                ConfusionRow(dimension: "典型例子", left: "根吸收无机盐离子", right: "葡萄糖进入红细胞"),
            ],
            quizzes: [
                ConfusionQuiz(id: "q1", statement: "既需要载体蛋白又消耗 ATP。", answerIsLeft: true,
                              explanation: "同时需载体和能量的是主动运输；协助扩散需载体但不耗能。"),
                ConfusionQuiz(id: "q2", statement: "顺浓度梯度、不消耗能量、但需要载体。", answerIsLeft: false,
                              explanation: "这是协助扩散的特征。"),
            ]),
        ConfusionPair(
            id: "cf_dna_rna", title: "DNA vs RNA",
            leftName: "DNA", rightName: "RNA",
            rows: [
                ConfusionRow(dimension: "五碳糖", left: "脱氧核糖", right: "核糖"),
                ConfusionRow(dimension: "碱基", left: "A T G C", right: "A U G C"),
                ConfusionRow(dimension: "链数", left: "一般双链", right: "一般单链"),
                ConfusionRow(dimension: "主要分布", left: "主要在细胞核", right: "主要在细胞质"),
            ],
            quizzes: [
                ConfusionQuiz(id: "q1", statement: "含有碱基 U（尿嘧啶）。", answerIsLeft: false,
                              explanation: "U 是 RNA 特有碱基；DNA 含 T 不含 U。"),
                ConfusionQuiz(id: "q2", statement: "含脱氧核糖、一般为双链。", answerIsLeft: true,
                              explanation: "DNA 含脱氧核糖、双链；RNA 含核糖、单链。"),
            ]),
        ConfusionPair(
            id: "cf_humoral_cellular", title: "体液免疫 vs 细胞免疫",
            leftName: "体液免疫", rightName: "细胞免疫",
            rows: [
                ConfusionRow(dimension: "主要效应细胞", left: "浆细胞（产生抗体）", right: "细胞毒性 T 细胞"),
                ConfusionRow(dimension: "作用对象", left: "主要清除细胞外的病原体", right: "主要清除被感染的靶细胞"),
                ConfusionRow(dimension: "是否产生抗体", left: "产生抗体", right: "不直接产生抗体"),
            ],
            quizzes: [
                ConfusionQuiz(id: "q1", statement: "由浆细胞产生抗体来发挥作用。", answerIsLeft: true,
                              explanation: "产生抗体的是体液免疫（浆细胞）；细胞免疫靠细胞毒性 T 细胞。"),
                ConfusionQuiz(id: "q2", statement: "直接裂解被病毒感染的靶细胞。", answerIsLeft: false,
                              explanation: "裂解靶细胞是细胞免疫中细胞毒性 T 细胞的作用。"),
            ]),
        ConfusionPair(
            id: "cf_j_s_growth", title: "J 形增长 vs S 形增长",
            leftName: "J 形增长", rightName: "S 形增长",
            rows: [
                ConfusionRow(dimension: "条件", left: "理想（食物空间无限、无天敌）", right: "资源和空间有限"),
                ConfusionRow(dimension: "是否有 K 值", left: "无 K 值", right: "有环境容纳量 K"),
                ConfusionRow(dimension: "增长率/速率", left: "增长率不变", right: "增长速率先增后减，K/2 时最大"),
            ],
            quizzes: [
                ConfusionQuiz(id: "q1", statement: "存在环境容纳量 K，种群数量最终稳定。", answerIsLeft: false,
                              explanation: "有 K 值的是 S 形增长；J 形增长无 K 值、持续增长。"),
                ConfusionQuiz(id: "q2", statement: "在 K/2 时种群增长速率最大。", answerIsLeft: false,
                              explanation: "K/2 增长速率最大是 S 形增长的特征。"),
            ]),
        ConfusionPair(
            id: "cf_photo_resp", title: "光合作用 vs 呼吸作用",
            leftName: "光合作用", rightName: "呼吸作用",
            rows: [
                ConfusionRow(dimension: "场所", left: "叶绿体", right: "主要在线粒体（第一阶段在细胞质基质）"),
                ConfusionRow(dimension: "物质变化", left: "无机物（CO₂、H₂O）→ 有机物", right: "有机物 → 无机物（CO₂、H₂O）"),
                ConfusionRow(dimension: "能量变化", left: "光能 → 储存在有机物中的化学能", right: "释放有机物中的化学能（部分转入 ATP）"),
                ConfusionRow(dimension: "气体", left: "吸收 CO₂、释放 O₂", right: "吸收 O₂、释放 CO₂"),
                ConfusionRow(dimension: "条件", left: "必须有光", right: "有光无光都进行"),
            ],
            quizzes: [
                ConfusionQuiz(id: "q1", statement: "把光能转变为有机物中的化学能。", answerIsLeft: true,
                              explanation: "储存能量、合成有机物的是光合作用；呼吸作用是释放能量、分解有机物。"),
                ConfusionQuiz(id: "q2", statement: "在线粒体中进行，释放 CO₂。", answerIsLeft: false,
                              explanation: "线粒体是有氧呼吸主要场所；光合在叶绿体且吸收 CO₂。"),
                ConfusionQuiz(id: "q3", statement: "只有在光照下才能进行。", answerIsLeft: true,
                              explanation: "光合作用需要光；呼吸作用昼夜都进行。"),
            ]),
        ConfusionPair(
            id: "cf_prokaryote_eukaryote", title: "原核细胞 vs 真核细胞",
            leftName: "原核细胞", rightName: "真核细胞",
            rows: [
                ConfusionRow(dimension: "核膜包被的细胞核", left: "无（只有拟核）", right: "有真正的细胞核"),
                ConfusionRow(dimension: "细胞器", left: "只有核糖体", right: "有线粒体、内质网等多种细胞器"),
                ConfusionRow(dimension: "遗传物质", left: "裸露的 DNA（集中在拟核）", right: "DNA 与蛋白质结合成染色体"),
                ConfusionRow(dimension: "代表生物", left: "细菌、蓝细菌（蓝藻）、放线菌", right: "动物、植物、真菌"),
            ],
            quizzes: [
                ConfusionQuiz(id: "q1", statement: "细胞内只有核糖体一种细胞器。", answerIsLeft: true,
                              explanation: "原核细胞唯一的细胞器是核糖体；真核细胞有多种细胞器。"),
                ConfusionQuiz(id: "q2", statement: "蓝细菌（蓝藻）属于此类。", answerIsLeft: true,
                              explanation: "蓝细菌无核膜包被的细胞核，是原核生物，能进行光合但无叶绿体。"),
                ConfusionQuiz(id: "q3", statement: "酵母菌、霉菌属于此类。", answerIsLeft: false,
                              explanation: "真菌（酵母菌、霉菌）有真正的细胞核，是真核生物。"),
            ]),
        ConfusionPair(
            id: "cf_free_bound_water", title: "自由水 vs 结合水",
            leftName: "自由水", rightName: "结合水",
            rows: [
                ConfusionRow(dimension: "存在状态", left: "可自由流动", right: "与其他物质结合、不能自由流动"),
                ConfusionRow(dimension: "主要作用", left: "良好溶剂、运输、参与反应", right: "细胞结构的重要组成成分"),
                ConfusionRow(dimension: "与代谢的关系", left: "比例越高，代谢越旺盛、抗逆性弱", right: "比例越高，代谢越弱、抗逆性强"),
            ],
            quizzes: [
                ConfusionQuiz(id: "q1", statement: "是细胞内良好的溶剂，并参与多种化学反应。", answerIsLeft: true,
                              explanation: "自由水是良好溶剂并参与反应；结合水是结构成分。"),
                ConfusionQuiz(id: "q2", statement: "其比例升高，细胞抗寒、抗旱能力增强。", answerIsLeft: false,
                              explanation: "结合水比例高时抗逆性强；自由水比例高时代谢旺盛但抗逆性弱。"),
            ]),
        ConfusionPair(
            id: "cf_mutation_recomb", title: "基因突变 vs 基因重组",
            leftName: "基因突变", rightName: "基因重组",
            rows: [
                ConfusionRow(dimension: "实质", left: "碱基的替换、增添或缺失，产生新基因（等位基因）", right: "原有基因的重新组合，不产生新基因"),
                ConfusionRow(dimension: "发生时期", left: "主要在间期 DNA 复制时", right: "减数分裂（减Ⅰ后期、四分体交叉互换）"),
                ConfusionRow(dimension: "对进化的意义", left: "生物变异的根本来源、为进化提供原材料", right: "形成生物多样性的重要原因（有性生殖）"),
            ],
            quizzes: [
                ConfusionQuiz(id: "q1", statement: "能产生新的基因（新的等位基因）。", answerIsLeft: true,
                              explanation: "只有基因突变能产生新基因；基因重组只是已有基因重新组合。"),
                ConfusionQuiz(id: "q2", statement: "发生在减数分裂过程中，非等位基因自由组合。", answerIsLeft: false,
                              explanation: "这是基因重组；基因突变主要发生在 DNA 复制（间期）。"),
            ]),
        ConfusionPair(
            id: "cf_nerve_humoral", title: "神经调节 vs 体液调节",
            leftName: "神经调节", rightName: "体液调节",
            rows: [
                ConfusionRow(dimension: "作用途径", left: "反射弧", right: "体液运输（如激素随血液运输）"),
                ConfusionRow(dimension: "反应速度", left: "迅速", right: "较缓慢"),
                ConfusionRow(dimension: "作用范围", left: "准确、比较局限", right: "较广泛"),
                ConfusionRow(dimension: "作用时间", left: "短暂", right: "比较长"),
            ],
            quizzes: [
                ConfusionQuiz(id: "q1", statement: "通过反射弧来完成，反应迅速、作用范围局限。", answerIsLeft: true,
                              explanation: "依赖反射弧、迅速准确的是神经调节。"),
                ConfusionQuiz(id: "q2", statement: "激素经血液运输作用于靶细胞，反应较缓慢、时间较长。", answerIsLeft: false,
                              explanation: "通过体液运输、缓慢而持久的是体液调节。"),
            ]),
        ConfusionPair(
            id: "cf_specific_nonspecific", title: "非特异性免疫 vs 特异性免疫",
            leftName: "非特异性免疫", rightName: "特异性免疫",
            rows: [
                ConfusionRow(dimension: "形成", left: "生来就有（先天性）", right: "出生后接触病原体后获得"),
                ConfusionRow(dimension: "对象", left: "对多种病原体都有防御作用", right: "针对特定的抗原"),
                ConfusionRow(dimension: "组成", left: "第一道防线（皮肤黏膜）+ 第二道防线（杀菌物质、吞噬细胞）", right: "第三道防线（免疫器官和免疫细胞）"),
                ConfusionRow(dimension: "是否有记忆", left: "无记忆细胞", right: "能产生记忆细胞"),
            ],
            quizzes: [
                ConfusionQuiz(id: "q1", statement: "皮肤和黏膜的屏障作用属于此类。", answerIsLeft: true,
                              explanation: "皮肤黏膜是第一道防线，属非特异性免疫。"),
                ConfusionQuiz(id: "q2", statement: "针对特定抗原，能产生记忆细胞。", answerIsLeft: false,
                              explanation: "针对特定抗原、有记忆细胞的是特异性免疫（第三道防线）。"),
            ]),
        ConfusionPair(
            id: "cf_antigen_antibody", title: "抗原 vs 抗体",
            leftName: "抗原", rightName: "抗体",
            rows: [
                ConfusionRow(dimension: "本质", left: "能引起机体产生免疫反应的物质（多为蛋白质等大分子）", right: "专门抗击抗原的蛋白质（免疫球蛋白）"),
                ConfusionRow(dimension: "来源", left: "多来自外界（病原体等），也可是自身异常物质", right: "由浆细胞（效应 B 细胞）产生"),
                ConfusionRow(dimension: "作用", left: "刺激机体发生特异性免疫", right: "与相应抗原特异性结合，使其失活/聚集"),
            ],
            quizzes: [
                ConfusionQuiz(id: "q1", statement: "由浆细胞产生，能与病原体特异性结合。", answerIsLeft: false,
                              explanation: "由浆细胞产生、特异性结合的是抗体。"),
                ConfusionQuiz(id: "q2", statement: "能刺激机体发生特异性免疫反应。", answerIsLeft: true,
                              explanation: "引起免疫反应的是抗原。"),
            ]),
        ConfusionPair(
            id: "cf_sample_markrecapture", title: "样方法 vs 标志重捕法",
            leftName: "样方法", rightName: "标志重捕法",
            rows: [
                ConfusionRow(dimension: "适用对象", left: "植物、活动范围小的动物（如蚯蚓）", right: "活动能力强、活动范围大的动物"),
                ConfusionRow(dimension: "关键操作", left: "随机取样、计算多个样方平均值", right: "标记—放回—重捕，按比例估算"),
                ConfusionRow(dimension: "估算依据", left: "样方密度代表整体密度", right: "总数 N = 第一次标记数 × 第二次捕获数 ÷ 重捕中标记数"),
            ],
            quizzes: [
                ConfusionQuiz(id: "q1", statement: "调查某草地蒲公英的种群密度宜用此法。", answerIsLeft: true,
                              explanation: "植物（蒲公英）用样方法，关键是随机取样。"),
                ConfusionQuiz(id: "q2", statement: "调查一片树林中麻雀的种群数量宜用此法。", answerIsLeft: false,
                              explanation: "活动能力强的麻雀用标志重捕法。"),
            ]),
        ConfusionPair(
            id: "cf_resistance_resilience", title: "抵抗力稳定性 vs 恢复力稳定性",
            leftName: "抵抗力稳定性", rightName: "恢复力稳定性",
            rows: [
                ConfusionRow(dimension: "含义", left: "抵抗外界干扰、保持原状的能力", right: "受破坏后恢复到原状的能力"),
                ConfusionRow(dimension: "与营养结构关系", left: "成分越多、结构越复杂越强", right: "成分越多、结构越复杂往往越弱"),
                ConfusionRow(dimension: "典型例子", left: "热带雨林较强", right: "草原、苔原恢复较快"),
            ],
            quizzes: [
                ConfusionQuiz(id: "q1", statement: "森林被砍伐后能较快重新长出，体现该稳定性强。", answerIsLeft: false,
                              explanation: "受破坏后恢复的能力是恢复力稳定性。"),
                ConfusionQuiz(id: "q2", statement: "生态系统营养结构越复杂，该稳定性越高。", answerIsLeft: true,
                              explanation: "营养结构越复杂，抵抗力稳定性越高（自我调节能力越强）。"),
            ]),
    ]
}
