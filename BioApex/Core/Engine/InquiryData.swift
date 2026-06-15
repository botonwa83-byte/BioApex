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
    ] + [
        InquiryCase(
            id: "iq_enzyme_ph", title: "pH 对酶活性的影响",
            question: "探究不同 pH 对淀粉酶催化淀粉水解的影响。",
            background: "酶的活性受 pH 影响,过酸或过碱会使酶变性失活,每种酶都有最适 pH。请设计严谨的探究实验。",
            steps: [
                InquiryStep(id: "s1", prompt: "本实验的自变量是？",
                            options: ["pH(酸碱度)", "酶的量", "底物的量", "温度"],
                            answerIndex: 0, explanation: "要探究的因素是 pH,应设置一系列不同 pH 梯度互为对照。"),
                InquiryStep(id: "s2", prompt: "温度这一因素应如何处理？",
                            options: ["各组控制在最适温度且相同", "每组设不同温度", "越高越好", "无需控制"],
                            answerIndex: 0, explanation: "温度是无关变量,必须各组相同且控制在最适温度,避免干扰对 pH 的判断。"),
                InquiryStep(id: "s3", prompt: "检测淀粉是否被分解,宜选用的试剂是？",
                            options: ["碘液(不需加热,避免引入温度干扰)", "斐林试剂(需水浴加热)", "双缩脲试剂", "苏丹Ⅲ染液"],
                            answerIndex: 0, explanation: "本实验需控温,斐林试剂检测还原糖要水浴加热会引入温度变化,故宜用碘液直接检测淀粉是否消失。"),
                InquiryStep(id: "s4", prompt: "预测结果曲线是？",
                            options: ["随 pH 升高先增大后减小,存在最适 pH", "一直增大", "一直减小", "始终不变"],
                            answerIndex: 0, explanation: "偏离最适 pH(过酸或过碱)酶活性下降甚至失活,故呈钟形,有最适 pH。"),
            ],
            principle: "自变量 pH(设梯度互为对照),因变量底物分解速率,无关变量(温度、酶量、底物量)等量且适宜;结果呈「有最适值」的钟形。"),

        InquiryCase(
            id: "iq_resp_yeast", title: "酵母菌的呼吸方式探究",
            question: "探究酵母菌在有氧和无氧条件下的呼吸方式及产物。",
            background: "酵母菌是兼性厌氧菌:有氧呼吸产生大量 CO₂,无氧呼吸产生酒精和少量 CO₂。通过对照检测 CO₂ 产量与酒精的有无来判断。",
            steps: [
                InquiryStep(id: "s1", prompt: "本实验的自变量是？",
                            options: ["是否提供氧气(有氧/无氧)", "酵母菌的量", "葡萄糖浓度", "温度"],
                            answerIndex: 0, explanation: "探究有氧与无氧两种条件,自变量是氧气的有无,需设有氧组和无氧组互为对照。"),
                InquiryStep(id: "s2", prompt: "如何制造「无氧」组的条件？",
                            options: ["先煮沸葡萄糖液冷却后接种并封闭、隔绝空气", "持续通入空气", "敞口放置", "加入过氧化氢"],
                            answerIndex: 0, explanation: "煮沸可排除溶解氧,冷却后接种并密封,营造无氧环境;有氧组则持续通入空气。"),
                InquiryStep(id: "s3", prompt: "用什么指标判断 CO₂ 的产生量多少？",
                            options: ["澄清石灰水变浑浊程度(或溴麝香草酚蓝水溶液变黄快慢)", "溶液变红的程度", "气味是否好闻", "液面高低"],
                            answerIndex: 0, explanation: "CO₂ 使澄清石灰水变浑浊,浑浊程度反映 CO₂ 多少;也可用溴麝香草酚蓝水溶液由蓝→绿→黄及变色快慢比较。"),
                InquiryStep(id: "s4", prompt: "如何检验是否产生了酒精？",
                            options: ["取样滴加橙色的酸性重铬酸钾溶液,变灰绿色说明有酒精", "加碘液变蓝", "加斐林试剂变砖红", "加双缩脲变紫"],
                            answerIndex: 0, explanation: "在酸性条件下,橙色的重铬酸钾与酒精反应变成灰绿色,可检验酒精的有无。"),
            ],
            principle: "自变量是 O₂ 有无(设有氧/无氧对照),因变量是 CO₂ 产量和酒精有无,无关变量(菌种、糖量、温度)相同且适宜。检测:CO₂—石灰水/溴麝香草酚蓝;酒精—酸性重铬酸钾(橙→灰绿)。"),

        InquiryCase(
            id: "iq_auxin_root", title: "生长素类似物促进生根的最适浓度",
            question: "探究某生长素类似物(如 NAA)促进插条生根的最适浓度。",
            background: "生长素及其类似物作用具两重性:低浓度促进、高浓度抑制生根。需通过浓度梯度找出最适浓度。",
            steps: [
                InquiryStep(id: "s1", prompt: "本实验的自变量是？",
                            options: ["生长素类似物的浓度", "插条的数量", "生根的条数", "处理时间"],
                            answerIndex: 0, explanation: "要找最适浓度,自变量就是生长素类似物的浓度,应设置一系列浓度梯度。"),
                InquiryStep(id: "s2", prompt: "为减少误差、使结果更可靠,每个浓度组应？",
                            options: ["用多支(一定数量)生长状况相同的插条,取平均值", "只用 1 支插条", "用不同种类的植物", "每组数量随意"],
                            answerIndex: 0, explanation: "每组用足够多且生长状况一致的插条求平均值,可减少偶然误差(重复原则)。"),
                InquiryStep(id: "s3", prompt: "是否需要设置「清水(不含生长素)」组？其作用是？",
                            options: ["需要,作空白对照,说明生根是生长素类似物引起的", "不需要", "需要,作为自变量", "需要,用来灭菌"],
                            answerIndex: 0, explanation: "清水组是空白对照,排除插条自身能生根的影响,凸显生长素类似物的作用。"),
                InquiryStep(id: "s4", prompt: "为缩小范围、节省材料,正式实验前常先做？",
                            options: ["预实验(粗略确定最适浓度的大致范围)", "重复三次正式实验", "直接得出结论", "更换植物种类"],
                            answerIndex: 0, explanation: "先做预实验确定大致浓度范围,再在该范围内细分梯度做正式实验,可减少盲目性、节省人力物力。"),
            ],
            principle: "自变量为浓度(梯度+清水空白对照),因变量为生根数量/长度,无关变量(插条种类、长度、芽数、处理时间、环境)相同且适宜;重复取平均,先预实验再正式实验。"),
    ]
}
