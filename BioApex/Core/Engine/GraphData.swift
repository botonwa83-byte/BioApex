import Foundation

// MARK: - 图表曲线分析数据（架子已立，内容可持续增量）

enum GraphData {
    static let all: [GraphCase] = [
        GraphCase(
            id: "gr_enzyme_temp", title: "酶活性 — 温度", scenario: "横轴温度、纵轴酶催化的反应速率。",
            xAxis: "温度", yAxis: "酶活性/反应速率", shape: .bell,
            readingPoints: ["最高点对应最适温度（此时酶活性最强）",
                            "低温段：温度低、酶活性低，但酶未失活（升温可恢复）",
                            "高温段：温度过高使酶变性失活，曲线急剧下降且不可逆"],
            quiz: ProcessQuiz(prompt: "曲线最高点对应的温度是？", options: ["最适温度", "致死温度", "室温"],
                              answerIndex: 0, explanation: "最高点酶活性最强，对应最适温度。")),
        GraphCase(
            id: "gr_photo_light", title: "光合速率 — 光照强度", scenario: "横轴光照强度、纵轴光合速率。",
            xAxis: "光照强度", yAxis: "光合速率", shape: .saturating,
            readingPoints: ["上升段：光是限制因素，增强光照光合加快",
                            "拐点（光饱和点）后曲线变平：光不再是限制因素",
                            "此后可通过增施 CO₂、调温进一步提高光合"],
            quiz: ProcessQuiz(prompt: "光饱和点之后限制光合速率的主要因素最可能是？",
                              options: ["CO₂ 浓度等", "光照强度", "叶绿素含量"],
                              answerIndex: 0, explanation: "光饱和后光不再是限制因素，CO₂ 浓度、温度等成为限制因素。")),
        GraphCase(
            id: "gr_pop_s", title: "种群数量 — 时间（S 形）", scenario: "资源和空间有限时种群数量随时间的变化。",
            xAxis: "时间", yAxis: "种群数量", shape: .sCurve,
            readingPoints: ["增长先快后慢，最终稳定在环境容纳量 K",
                            "K/2 时种群增长速率最大（适合作为持续获取资源的参考）",
                            "K 值随环境改变，不是固定不变的"],
            quiz: ProcessQuiz(prompt: "S 形增长曲线中种群增长速率最大的点是？",
                              options: ["K/2 处", "K 处", "起点"],
                              answerIndex: 0, explanation: "K/2 时增长速率最大；到 K 时增长速率为 0。")),
    ]
}
