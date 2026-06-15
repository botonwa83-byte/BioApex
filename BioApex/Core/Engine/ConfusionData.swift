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
    ]
}
