import Foundation

// MARK: - 生命的尺度（生命系统的结构层次 + 尺度漫游）
// 课标：细胞是最基本的生命系统，生物圈是最大的生命系统；病毒不属于生命系统层次。

enum ScaleData {
    static let all: [ScaleLevel] = [
        ScaleLevel(id: "molecule", order: 0, name: "生物大分子", scale: "~1 nm",
                   summary: "蛋白质、核酸、多糖等生命的物质基础。",
                   example: "DNA 双螺旋、血红蛋白",
                   isLifeSystem: false, note: "分子不是独立的生命系统层次，但是生命的物质基础。"),
        ScaleLevel(id: "organelle", order: 1, name: "细胞器", scale: "~0.1–1 μm",
                   summary: "细胞内具有特定功能的结构，如线粒体、叶绿体。",
                   example: "线粒体、核糖体",
                   isLifeSystem: false, note: "细胞器是细胞的组成部分，本身不是生命系统层次。"),
        ScaleLevel(id: "cell", order: 2, name: "细胞", scale: "~10–100 μm",
                   summary: "最基本的生命系统——能独立完成各项生命活动的基本单位。",
                   example: "神经细胞、草履虫",
                   note: "细胞是最基本的生命系统层次。"),
        ScaleLevel(id: "tissue", order: 3, name: "组织", scale: "mm 级",
                   summary: "形态相似、功能相同的细胞联合在一起。",
                   example: "上皮组织、叶肉组织"),
        ScaleLevel(id: "organ", order: 4, name: "器官", scale: "cm 级",
                   summary: "不同组织按一定次序组合，行使特定功能。",
                   example: "心脏、叶、胃"),
        ScaleLevel(id: "system", order: 5, name: "系统", scale: "—",
                   summary: "能完成一种或几种生理功能的多个器官按顺序组合。",
                   example: "消化系统、神经系统",
                   note: "植物没有'系统'这一层次。"),
        ScaleLevel(id: "individual", order: 6, name: "个体", scale: "—",
                   summary: "一个完整的生物体。单细胞生物一个细胞就是一个个体。",
                   example: "一株小麦、一个人"),
        ScaleLevel(id: "population", order: 7, name: "种群", scale: "—",
                   summary: "一定区域内同种生物的全部个体。",
                   example: "一片草原上的所有羊"),
        ScaleLevel(id: "community", order: 8, name: "群落", scale: "—",
                   summary: "一定区域内所有生物（各种群）的集合。",
                   example: "一个池塘里的全部生物"),
        ScaleLevel(id: "ecosystem", order: 9, name: "生态系统", scale: "—",
                   summary: "生物群落与它的无机环境相互作用形成的统一整体。",
                   example: "一片森林、一个湖泊"),
        ScaleLevel(id: "biosphere", order: 10, name: "生物圈", scale: "全球",
                   summary: "地球上全部生物及其无机环境的总和——最大的生命系统。",
                   example: "整个地球生命圈",
                   note: "生物圈是最大的生命系统层次。"),
    ]
}
