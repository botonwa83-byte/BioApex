import XCTest
@testable import BioApex

final class BioApexTests: XCTestCase {

    /// 考点 ID 全局唯一。
    func testKnowledgePointIdsUnique() {
        let ids = SyllabusData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "考点 ID 重复")
        XCTAssertFalse(SyllabusData.all.isEmpty)
    }

    /// 每个考点必须有非空精讲，权重 1–3。
    func testKnowledgePointContent() {
        for p in SyllabusData.all {
            XCTAssertFalse(p.essence.isEmpty, "考点 \(p.id) 缺精讲")
            XCTAssertFalse(p.title.isEmpty, "考点 \(p.id) 缺标题")
            XCTAssertTrue((1...3).contains(p.weight), "考点 \(p.id) 权重越界")
        }
    }

    /// 考点引用的过程剧场必须真实存在。
    func testProcessReferencesResolve() {
        let sceneIds = Set(ProcessData.all.map(\.id))
        for p in SyllabusData.all {
            if let pid = p.processId {
                XCTAssertTrue(sceneIds.contains(pid), "考点 \(p.id) 引用了不存在的过程 \(pid)")
            }
        }
    }

    /// 过程剧场完整性：ID 唯一、至少 2 步、断点填空答案合法。
    func testProcessIntegrity() {
        let ids = ProcessData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "过程 ID 重复")
        for s in ProcessData.all {
            XCTAssertGreaterThanOrEqual(s.stages.count, 2, "过程 \(s.id) 步骤太少")
            XCTAssertFalse(s.location.isEmpty)
            XCTAssertFalse(s.examHook.isEmpty, "过程 \(s.id) 缺钩回考点")
            for stage in s.stages {
                if let q = stage.quiz {
                    XCTAssertTrue(q.options.indices.contains(q.answerIndex), "过程 \(s.id) 断点答案越界")
                    XCTAssertGreaterThanOrEqual(q.options.count, 2)
                    XCTAssertFalse(q.explanation.isEmpty)
                }
            }
        }
    }

    /// 内购划线：初中 + 必修1 免费；其余付费；过程前 4 免费。
    func testFreeTierPolicy() {
        XCTAssertTrue(BioModule.junior.isFree, "初中必须免费")
        XCTAssertTrue(BioModule.molecule.isFree, "必修1必须免费")
        XCTAssertFalse(BioModule.genetics.isFree, "必修2应付费")
        XCTAssertFalse(BioModule.homeostasis.isFree)
        XCTAssertFalse(BioModule.ecology.isFree)
        XCTAssertFalse(BioModule.biotech.isFree)
        // 免费过程数量不超过总数
        XCTAssertLessThanOrEqual(PurchaseManager.freeProcessCount, ProcessData.all.count)
        // 前 4 个免费过程应来自免费模块（钩子）
        let freeScenes = ProcessData.all.prefix(PurchaseManager.freeProcessCount)
        XCTAssertTrue(freeScenes.allSatisfy { $0.module.isFree }, "免费过程应属于免费模块")
    }

    /// 考点深化（P9）：已深化考点的 related 关联 id 必须真实存在；至少深化了若干高频考点。
    func testDeepenedPoints() {
        let ids = Set(SyllabusData.all.map(\.id))
        let deepened = SyllabusData.all.filter { $0.isDeepened }
        XCTAssertGreaterThanOrEqual(deepened.count, 6, "应已深化若干高频考点")
        for p in deepened {
            XCTAssertFalse(p.detail.isEmpty)
            for r in p.related {
                XCTAssertTrue(ids.contains(r), "考点 \(p.id) 关联了不存在的考点 \(r)")
            }
        }
    }

    /// 题库（P10）：ID 唯一、所属考点存在、答案/采分点/解析合法。
    func testQuestionData() {
        let ids = QuestionData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "题目 ID 重复")
        let kpIds = Set(SyllabusData.all.map(\.id))
        for q in QuestionData.all {
            XCTAssertTrue(kpIds.contains(q.kpId), "题 \(q.id) 所属考点 \(q.kpId) 不存在")
            XCTAssertFalse(q.stem.isEmpty); XCTAssertFalse(q.explanation.isEmpty)
            switch q.type {
            case .choice:
                XCTAssertGreaterThanOrEqual(q.options.count, 2, "题 \(q.id) 选项太少")
                XCTAssertTrue(q.options.indices.contains(q.answerIndex), "题 \(q.id) 答案越界")
            case .shortAnswer:
                XCTAssertFalse(q.modelAnswer.isEmpty, "题 \(q.id) 缺标准答案")
                XCTAssertGreaterThanOrEqual(q.scorePoints.count, 2, "题 \(q.id) 采分点太少")
            }
        }
    }

    /// 配题按权重：已配题的高频(weight=3)考点应 ≥2 题。
    func testQuestionWeightCalibration() {
        for p in SyllabusData.all where p.weight == 3 && QuestionData.hasQuestions(p.id) {
            XCTAssertGreaterThanOrEqual(QuestionData.questions(for: p.id).count, 2,
                                        "高频考点 \(p.id) 配题应 ≥2")
        }
        XCTAssertFalse(QuestionData.all.isEmpty)
    }

    /// 图表曲线（P11）：ID 唯一、读图要点≥2、quiz 答案合法。
    func testGraphData() {
        let ids = GraphData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "图表 ID 重复")
        for g in GraphData.all {
            XCTAssertGreaterThanOrEqual(g.readingPoints.count, 2, "图表 \(g.id) 读图要点太少")
            XCTAssertTrue(g.quiz.options.indices.contains(g.quiz.answerIndex), "图表 \(g.id) quiz 答案越界")
            XCTAssertFalse(g.quiz.explanation.isEmpty)
        }
    }

    /// 概念关联网（P11）：每个生命观念都有关联考点，且 id 真实存在。
    func testConceptMap() {
        let kpIds = Set(SyllabusData.all.map(\.id))
        for c in LifeConcept.allCases {
            let pts = ConceptData.map[c] ?? []
            XCTAssertFalse(pts.isEmpty, "生命观念 \(c.title) 没有关联考点")
            for id in pts { XCTAssertTrue(kpIds.contains(id), "概念网引用了不存在的考点 \(id)") }
        }
    }

    /// 武器库：每把武器都有教学，识局信号与步骤非空，例题 id 合法。
    func testWeaponLibrary() {
        let taught = Set(WeaponData.all.map(\.weapon))
        for w in BioWeapon.allCases {
            XCTAssertTrue(taught.contains(w), "武器 \(w.name) 缺教学")
        }
        let challengeIds = Set(ChallengeData.all.map(\.id))
        for g in WeaponData.all {
            XCTAssertFalse(g.whenToUse.isEmpty, "武器 \(g.weapon.name) 缺识局信号")
            XCTAssertFalse(g.steps.isEmpty, "武器 \(g.weapon.name) 缺步骤")
            if let ex = g.exampleChallengeId {
                XCTAssertTrue(challengeIds.contains(ex), "武器 \(g.weapon.name) 例题 \(ex) 不存在")
            }
        }
    }

    /// 破题之眼：ID 唯一、步骤/答案/迁移非空、难度 1–5；免费档不超总数。
    func testChallengeData() {
        let ids = ChallengeData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "压轴题 ID 重复")
        for p in ChallengeData.all {
            XCTAssertFalse(p.content.isEmpty); XCTAssertFalse(p.keyInsight.isEmpty)
            XCTAssertFalse(p.steps.isEmpty); XCTAssertFalse(p.answer.isEmpty)
            XCTAssertFalse(p.takeaway.isEmpty, "题 \(p.id) 缺方法迁移")
            XCTAssertTrue((1...5).contains(p.difficulty))
        }
        XCTAssertLessThanOrEqual(PurchaseManager.freeChallengeCount, ChallengeData.all.count)
    }

    /// 每个教材模块都要有考点（不能空模块）。
    func testEveryModuleHasPoints() {
        for m in BioModule.allCases {
            XCTAssertFalse(SyllabusData.points(in: m).isEmpty, "模块 \(m.shortTitle) 没有考点")
        }
    }

    /// 生物巨人 / 生命档案馆：ID 唯一、内容完整。
    func testGiantsAndLore() {
        let gids = GiantsData.all.map(\.id)
        XCTAssertEqual(Set(gids).count, gids.count, "巨人 ID 重复")
        XCTAssertGreaterThanOrEqual(GiantsData.all.count, 5)
        for g in GiantsData.all {
            XCTAssertFalse(g.achievement.isEmpty, "巨人 \(g.id) 缺成就")
            XCTAssertFalse(g.story.isEmpty, "巨人 \(g.id) 缺小传")
        }
        let sids = LoreData.stories.map(\.id)
        XCTAssertEqual(Set(sids).count, sids.count, "故事 ID 重复")
        for s in LoreData.stories {
            XCTAssertFalse(s.body.isEmpty, "故事 \(s.id) 缺正文")
            XCTAssertFalse(s.examHook.isEmpty, "故事 \(s.id) 缺钩回考点")
        }
    }

    /// 细胞图鉴：ID 唯一、内容完整、关联过程合法。
    func testOrganelleData() {
        let ids = OrganelleData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "细胞器 ID 重复")
        let sceneIds = Set(ProcessData.all.map(\.id))
        for o in OrganelleData.all {
            XCTAssertFalse(o.structure.isEmpty, "细胞器 \(o.id) 缺结构")
            XCTAssertFalse(o.function.isEmpty, "细胞器 \(o.id) 缺功能")
            XCTAssertTrue((1...3).contains(o.examHeat))
            if let pid = o.relatedProcessId {
                XCTAssertTrue(sceneIds.contains(pid), "细胞器 \(o.id) 关联了不存在的过程 \(pid)")
            }
        }
        // 动物细胞应含线粒体不含叶绿体；植物细胞应含叶绿体
        let animal = OrganelleData.organelles(in: .animalOnly).map(\.id)
        XCTAssertTrue(animal.contains("mito"))
        XCTAssertFalse(animal.contains("chloro"), "动物细胞不应有叶绿体")
        XCTAssertTrue(OrganelleData.organelles(in: .plantOnly).map(\.id).contains("chloro"))
    }

    /// 生命尺度：order 连续递增、ID 唯一。
    func testScaleData() {
        let orders = ScaleData.all.map(\.order)
        XCTAssertEqual(orders, Array(0..<ScaleData.all.count), "尺度层次 order 必须连续递增")
        XCTAssertEqual(Set(ScaleData.all.map(\.id)).count, ScaleData.all.count)
        // 细胞是最基本生命系统、生物圈是最大
        XCTAssertTrue(ScaleData.all.first { $0.id == "cell" }!.isLifeSystem)
        XCTAssertEqual(ScaleData.all.last?.id, "biosphere")
    }

    /// 遗传秒算：ID 唯一、答案合法、秒算确实更快、原理充分。
    func testGeneticsDuels() {
        let ids = GeneticsData.duels.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "遗传秒算 ID 重复")
        for c in GeneticsData.duels {
            XCTAssertTrue(c.options.indices.contains(c.answerIndex), "秒算 \(c.id) 答案越界")
            XCTAssertGreaterThan(c.duo.timeRatio, 1, "秒算 \(c.id) 不比常规快")
            XCTAssertGreaterThan(c.duo.principle.count, 30, "秒算 \(c.id) 原理太简略")
            XCTAssertFalse(c.duo.plainTalk.isEmpty)
        }
    }

    /// 遗传神探：ID 唯一、线索≥2、答案合法、结案非空；免费档不超过总数。
    func testPedigreeCases() {
        let ids = GeneticsData.pedigrees.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "系谱案件 ID 重复")
        for c in GeneticsData.pedigrees {
            XCTAssertGreaterThanOrEqual(c.clues.count, 2, "案件 \(c.id) 线索太少")
            XCTAssertTrue(c.options.indices.contains(c.answerIndex), "案件 \(c.id) 答案越界")
            XCTAssertFalse(c.verdict.isEmpty)
            for clue in c.clues { XCTAssertFalse(clue.deduction.isEmpty, "线索 \(clue.id) 缺推理价值") }
        }
        XCTAssertLessThanOrEqual(PurchaseManager.freeDetectiveCount, GeneticsData.pedigrees.count)
    }

    /// 探究实验台：ID 唯一、每步答案合法、有原则小结。
    func testInquiryData() {
        let ids = InquiryData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "探究案例 ID 重复")
        for c in InquiryData.all {
            XCTAssertGreaterThanOrEqual(c.steps.count, 3, "案例 \(c.id) 设计步骤太少")
            XCTAssertFalse(c.principle.isEmpty)
            for s in c.steps {
                XCTAssertTrue(s.options.indices.contains(s.answerIndex), "步骤 \(s.id) 答案越界")
                XCTAssertFalse(s.explanation.isEmpty)
            }
        }
    }

    /// 易混辨析：ID 唯一、对比维度≥2、辨析题答案有解析。
    func testConfusionData() {
        let ids = ConfusionData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "辨析对 ID 重复")
        for p in ConfusionData.all {
            XCTAssertGreaterThanOrEqual(p.rows.count, 2, "辨析 \(p.id) 对比维度太少")
            XCTAssertFalse(p.quizzes.isEmpty, "辨析 \(p.id) 缺判断题")
            for q in p.quizzes { XCTAssertFalse(q.explanation.isEmpty) }
        }
    }

    /// SM-2 排期：答对升档（1→3→7→15→30→60 封顶），答错回 0 档。
    func testReviewIntervals() {
        XCTAssertEqual(ReviewScheduler.nextLevel(current: 0, correct: true), 1)
        XCTAssertEqual(ReviewScheduler.nextLevel(current: 4, correct: true), 5)
        XCTAssertEqual(ReviewScheduler.nextLevel(current: 5, correct: true), 5, "最高档封顶")
        XCTAssertEqual(ReviewScheduler.nextLevel(current: 3, correct: false), 0, "答错重置")
        XCTAssertEqual(ReviewScheduler.intervals, [1, 3, 7, 15, 30, 60])
    }

    /// 稳态回路：ID 唯一、升/降调节链非空、有结果。
    func testHomeostasisData() {
        let ids = HomeostasisData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "稳态回路 ID 重复")
        for loop in HomeostasisData.all {
            XCTAssertFalse(loop.high.chain.isEmpty, "回路 \(loop.id) 缺偏高调节链")
            XCTAssertFalse(loop.low.chain.isEmpty, "回路 \(loop.id) 缺偏低调节链")
            XCTAssertFalse(loop.high.result.isEmpty)
            XCTAssertFalse(loop.low.result.isEmpty)
            XCTAssertFalse(loop.note.isEmpty)
        }
    }
}
