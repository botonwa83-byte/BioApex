import Foundation

// MARK: - 细胞图鉴数据（细胞器与结构）
// 红线：膜层、结构、功能必须准确（学生直接背进考场）。

enum OrganelleData {
    static let all: [Organelle] = [
        Organelle(id: "membrane", name: "细胞膜", icon: "circle.dashed",
                  structure: "磷脂双分子层 + 蛋白质，流动镶嵌模型",
                  function: "分隔内外、控制物质进出、进行细胞间信息交流；具选择透过性",
                  examHeat: 3, presence: .both, membrane: "单层膜（边界）"),
        Organelle(id: "wall", name: "细胞壁", icon: "square.grid.3x3",
                  structure: "主要由纤维素和果胶组成",
                  function: "支持和保护植物细胞；全透性，不控制物质进出",
                  examHeat: 2, presence: .plantOnly, membrane: "非膜结构"),
        Organelle(id: "nucleus", name: "细胞核", icon: "circle.circle.fill",
                  structure: "核膜（双层、有核孔）、核仁、染色质",
                  function: "遗传信息库，是细胞代谢和遗传的控制中心",
                  examHeat: 3, presence: .both, membrane: "双层膜"),
        Organelle(id: "mito", name: "线粒体", icon: "oval.fill",
                  structure: "双层膜，内膜向内折叠成嵴，含少量 DNA",
                  function: "有氧呼吸的主要场所，细胞的'动力车间'",
                  examHeat: 3, presence: .both, relatedProcessId: "ps_respiration", membrane: "双层膜"),
        Organelle(id: "chloro", name: "叶绿体", icon: "leaf.fill",
                  structure: "双层膜，内有基粒（类囊体堆叠）和基质，含色素与 DNA",
                  function: "光合作用的场所，把光能转化为化学能",
                  examHeat: 3, presence: .plantOnly, relatedProcessId: "ps_photosynthesis", membrane: "双层膜"),
        Organelle(id: "er", name: "内质网", icon: "scribble.variable",
                  structure: "膜连成网状，分粗面（有核糖体）与滑面",
                  function: "蛋白质和脂质的合成、加工与运输通道",
                  examHeat: 2, presence: .both, membrane: "单层膜"),
        Organelle(id: "golgi", name: "高尔基体", icon: "tray.2.fill",
                  structure: "扁平囊和小泡堆叠",
                  function: "对蛋白质加工、分类、包装和分泌；植物中还参与细胞壁形成",
                  examHeat: 2, presence: .both, membrane: "单层膜"),
        Organelle(id: "ribosome", name: "核糖体", icon: "circlebadge.2.fill",
                  structure: "由 rRNA 和蛋白质组成，无膜",
                  function: "蛋白质合成（翻译）的场所，'生产机器'",
                  examHeat: 3, presence: .both, relatedProcessId: "ps_translation", membrane: "无膜"),
        Organelle(id: "vacuole", name: "液泡", icon: "drop.fill",
                  structure: "单层膜，内含细胞液（成熟植物细胞中央大液泡）",
                  function: "维持细胞渗透吸水、调节膨压、储存物质",
                  examHeat: 2, presence: .plantOnly, relatedProcessId: "ps_osmosis", membrane: "单层膜"),
        Organelle(id: "lysosome", name: "溶酶体", icon: "trash.circle.fill",
                  structure: "单层膜小泡，含多种水解酶",
                  function: "分解衰老损伤的细胞器、吞噬并杀死入侵的病菌，'消化车间'",
                  examHeat: 1, presence: .animalOnly, membrane: "单层膜"),
        Organelle(id: "centrosome", name: "中心体", icon: "asterisk",
                  structure: "由两个互相垂直的中心粒构成，无膜",
                  function: "与动物细胞和低等植物细胞的有丝分裂有关（形成纺锤体）",
                  examHeat: 1, presence: .animalOnly, relatedProcessId: "ps_mitosis", membrane: "无膜"),
        Organelle(id: "cytosol", name: "细胞质基质", icon: "circle.hexagongrid.fill",
                  structure: "细胞质中除细胞器外的胶状物质",
                  function: "多种代谢反应的场所（如有氧呼吸第一阶段、无氧呼吸）",
                  examHeat: 2, presence: .both, membrane: "—"),
    ]

    static func organelles(in presence: CellPresence) -> [Organelle] {
        // presence=plant 显示 both + plantOnly；animal 显示 both + animalOnly
        all.filter { $0.presence == .both || $0.presence == presence }
    }
}
