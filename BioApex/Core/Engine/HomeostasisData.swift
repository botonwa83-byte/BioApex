import Foundation

// MARK: - 稳态回路数据（负反馈调节）
// 红线：调节器官、激素、效应必须准确（血糖/体温为高频考点）。

enum HomeostasisData {
    static let all: [FeedbackLoop] = [
        FeedbackLoop(
            id: "fb_glucose", name: "血糖调节", variable: "血糖",
            setPoint: "正常 3.9–6.1 mmol/L",
            regulator: "胰岛（神经—体液共同调节）",
            high: FeedbackResponse(
                trigger: "血糖偏高（如饭后）",
                chain: ["血糖升高刺激胰岛 B 细胞", "胰岛 B 细胞分泌胰岛素↑",
                        "促进组织细胞摄取、利用、储存葡萄糖（合成肝糖原/肌糖原）",
                        "抑制肝糖原分解和非糖物质转化"],
                result: "血糖降回正常范围"),
            low: FeedbackResponse(
                trigger: "血糖偏低（如饥饿）",
                chain: ["血糖降低刺激胰岛 A 细胞", "胰岛 A 细胞分泌胰高血糖素↑（肾上腺素协同）",
                        "促进肝糖原分解为葡萄糖", "促进非糖物质转化为葡萄糖"],
                result: "血糖升回正常范围"),
            note: "胰岛素与胰高血糖素是拮抗关系;血糖回稳后又抑制相应激素分泌,这正是负反馈。"),

        FeedbackLoop(
            id: "fb_temp", name: "体温调节", variable: "体温",
            setPoint: "约 37 ℃",
            regulator: "下丘脑体温调节中枢（神经—体液共同调节）",
            high: FeedbackResponse(
                trigger: "体温偏高（炎热）",
                chain: ["皮肤温觉感受器→下丘脑体温调节中枢", "皮肤血管舒张、血流量增多",
                        "汗腺分泌增多", "散热量增加"],
                result: "体温降回 37 ℃ 左右"),
            low: FeedbackResponse(
                trigger: "体温偏低（寒冷）",
                chain: ["皮肤冷觉感受器→下丘脑体温调节中枢", "皮肤血管收缩、减少散热",
                        "骨骼肌不自主战栗、立毛肌收缩", "甲状腺激素、肾上腺素增多→代谢加强,产热增加"],
                result: "体温升回 37 ℃ 左右"),
            note: "体温恒定=产热与散热动态平衡;调节中枢在下丘脑,属于负反馈。"),
    ]
}
