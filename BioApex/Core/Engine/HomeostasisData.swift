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
    ] + [
        FeedbackLoop(
            id: "fb_thyroid", name: "甲状腺激素分级调节", variable: "甲状腺激素",
            setPoint: "血液中甲状腺激素维持相对稳定",
            regulator: "下丘脑—垂体—甲状腺轴（神经—体液调节）",
            high: FeedbackResponse(
                trigger: "甲状腺激素偏高",
                chain: ["血液中甲状腺激素含量升高", "（负反馈）抑制下丘脑和垂体",
                        "下丘脑分泌促甲状腺激素释放激素(TRH)↓、垂体分泌促甲状腺激素(TSH)↓",
                        "甲状腺受到的刺激减弱、分泌减少"],
                result: "甲状腺激素回落到正常水平"),
            low: FeedbackResponse(
                trigger: "甲状腺激素偏低（如寒冷、缺碘）",
                chain: ["寒冷刺激或激素偏低→下丘脑分泌 TRH↑", "垂体分泌 TSH↑",
                        "促进甲状腺分泌甲状腺激素↑", "促进新陈代谢、增加产热"],
                result: "甲状腺激素回升、代谢增强"),
            note: "分级调节：下丘脑→垂体→甲状腺;甲状腺激素增多又反过来抑制下丘脑和垂体,这是典型的(负)反馈调节。"),

        FeedbackLoop(
            id: "fb_water", name: "水盐平衡调节", variable: "细胞外液渗透压",
            setPoint: "细胞外液渗透压相对稳定",
            regulator: "下丘脑渗透压感受器—垂体（抗利尿激素）—肾（神经—体液调节）",
            high: FeedbackResponse(
                trigger: "渗透压偏高（如失水过多、吃得过咸）",
                chain: ["细胞外液渗透压升高刺激下丘脑渗透压感受器", "垂体释放抗利尿激素↑",
                        "促进肾小管、集合管重吸收水↑→尿量减少", "下丘脑兴奋传至大脑皮层产生渴觉→主动饮水"],
                result: "渗透压降回正常"),
            low: FeedbackResponse(
                trigger: "渗透压偏低（如大量饮水）",
                chain: ["细胞外液渗透压降低", "下丘脑渗透压感受器兴奋减弱→垂体释放抗利尿激素↓",
                        "肾小管、集合管重吸收水减少", "尿量增多、排出多余水分"],
                result: "渗透压升回正常"),
            note: "抗利尿激素由下丘脑合成、垂体释放;水盐平衡是神经调节与体液调节共同作用的负反馈过程。"),
    ]
}
