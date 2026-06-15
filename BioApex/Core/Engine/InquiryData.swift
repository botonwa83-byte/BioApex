import Foundation

// MARK: - 探究实验台数据
// 红线：变量判定、对照与等量原则、结果预测必须符合科学探究规范。

enum InquiryData {
    static let all: [InquiryCase] = [
        InquiryCase(
            id: "iq_enzyme_temp", title: "温度对酶活性的影响",
            question: "探究温度对淀粉酶催化淀粉水解速率的影响。",
            background: "酶的活性受温度影响,过高会使酶变性失活。请设计严谨的探究实验。",
            steps: [
                InquiryStep(id: "s1", prompt: "本实验的自变量是？",
                            options: ["温度", "淀粉酶的量", "淀粉的量", "反应时间"],
                            answerIndex: 0, explanation: "要探究的因素就是自变量——温度。"),
                InquiryStep(id: "s2", prompt: "因变量（检测指标）应是？",
                            options: ["淀粉水解的速率（如淀粉剩余量）", "温度高低", "试管的数量", "酶的种类"],
                            answerIndex: 0, explanation: "随自变量变化、被测量的量是因变量——这里用淀粉水解速率（可用碘液检测淀粉是否消失）。"),
                InquiryStep(id: "s3", prompt: "对无关变量（酶量、底物量、pH 等）应如何处理？",
                            options: ["各组保持相同且适宜", "每组都设不同值", "只在高温组控制", "无需控制"],
                            answerIndex: 0, explanation: "单一变量原则+等量原则:除温度外,其他条件各组都相同且适宜,排除干扰。"),
                InquiryStep(id: "s4", prompt: "预测结果曲线最可能是？",
                            options: ["随温度升高先加快后减慢,存在最适温度", "一直加快", "一直不变", "一直减慢"],
                            answerIndex: 0, explanation: "低温酶活性低、最适温度活性最高、高温酶变性失活,故呈「先升后降」的钟形,有最适温度。"),
            ],
            principle: "三大原则:①单一变量(只让温度变);②对照(设置不同温度梯度互为对照);③等量(无关变量等量且适宜)。"),

        InquiryCase(
            id: "iq_light_photo", title: "光照强度对光合作用的影响",
            question: "探究光照强度对某水生植物光合作用强度的影响。",
            background: "可通过单位时间内释放的气泡数（O₂）反映光合作用强度。",
            steps: [
                InquiryStep(id: "s1", prompt: "本实验的自变量是？",
                            options: ["光照强度", "CO₂浓度", "水温", "植物种类"],
                            answerIndex: 0, explanation: "要探究的因素是光照强度（可用台灯远近控制）。"),
                InquiryStep(id: "s2", prompt: "用什么作因变量指标？",
                            options: ["单位时间释放的气泡数(O₂)", "光照强度", "水的体积", "时间长短"],
                            answerIndex: 0, explanation: "用单位时间气泡数(O₂释放量)间接反映光合作用强度。"),
                InquiryStep(id: "s3", prompt: "温度、CO₂浓度等无关变量应？",
                            options: ["各组相同且适宜", "随光照一起变", "不用管", "越高越好"],
                            answerIndex: 0, explanation: "无关变量需相同且适宜,否则无法判断是光照还是其他因素引起的变化。"),
                InquiryStep(id: "s4", prompt: "预测结果：",
                            options: ["一定范围内随光照增强而增大,超过光饱和点后不再增大", "一直线性增大", "一直减小", "始终不变"],
                            answerIndex: 0, explanation: "光照较弱时是限制因素,增强则光合增强;达到光饱和点后,CO₂等成为限制因素,不再增大。"),
            ],
            principle: "找准三类变量:自变量(光照)、因变量(O₂释放)、无关变量(温度/CO₂等,需等量适宜);预测要结合「限制因素」。"),
    ]
}
