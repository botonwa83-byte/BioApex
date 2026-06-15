import SwiftUI

// MARK: - 考点详情：学（精讲）→ 看过程（如有）→ 标记掌握
// 不堆题海：每个考点用"精讲 + 自评掌握"闭环；带过程的可跳过程剧场。

struct KnowledgePointDetailView: View {
    let point: KnowledgePoint
    @ObservedObject private var mastery = MasteryManager.shared
    @ObservedObject private var mistakes = MistakeManager.shared
    @ObservedObject private var questions = QuestionManager.shared
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    private var kpQuestions: [Question] { QuestionData.questions(for: point.id) }

    private var scene: ProcessScene? { point.processId.flatMap { ProcessData.scene(id: $0) } }

    /// 付费考点未解锁：试看模式（露出 essence 钩子，锁住深讲/题）。
    private var locked: Bool { purchase.isPointPremiumLocked(point) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                essenceCard
                if locked {
                    lockedTeaser
                } else {
                    if !point.detail.isEmpty { detailCard }
                    if let s = scene { processEntry(s) }
                    if let exam = point.examAngle { examCard(exam) }
                    if let mem = point.memoryAid { memCard(mem) }
                    if let err = point.commonError { errorCard(err) }
                    if !relatedPoints.isEmpty { relatedCard }
                    if kpQuestions.isEmpty { masteryControl } else { practiceSection }
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle(point.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    // MARK: 试看软付费墙（B）：免费看一句话钩子，深讲与配题就地引导解锁
    private var lockedTeaser: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: 6) {
                Image(systemName: "eye.fill").font(.caption).foregroundColor(.bioGold)
                Text("以上为免费试看 · 完整精讲已锁定").font(AppFont.chip).foregroundColor(.bioGold)
            }
            VStack(alignment: .leading, spacing: 10) {
                lockRow("text.book.closed", "深讲讲透 \(point.detail.count) 条", show: !point.detail.isEmpty)
                lockRow("scope", "高考命题角度精析", show: point.examAngle != nil)
                lockRow("brain.head.profile", "记忆术 · 口诀", show: point.memoryAid != nil)
                lockRow("play.circle.fill", "关联过程剧场动态演示", show: scene != nil)
                lockRow("exclamationmark.triangle.fill", "易错警示", show: point.commonError != nil)
                lockRow("checklist", "\(kpQuestions.count) 道精准诊断题", show: !kpQuestions.isEmpty)
                lockRow("point.3.connected.trianglepath.dotted", "关联考点网", show: !relatedPoints.isEmpty)
            }
            Button { showPaywall = true } label: {
                HStack(spacing: 8) {
                    Image(systemName: "lock.open.fill")
                    Text("解锁完整精讲").fontWeight(.bold)
                }
                .font(.headline).foregroundColor(.white)
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(LinearGradient(colors: [.bioGreen, .bioTeal], startPoint: .leading, endPoint: .trailing))
                .cornerRadius(Radius.inner)
            }
            .buttonStyle(.plain)
            Text("\(point.module.shortTitle)属于完整版内容；一次买断，永久解锁必修2 + 选必全部考点。")
                .font(.caption2).foregroundColor(.secondary).multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(Color.bioGold.opacity(0.08))
        .cornerRadius(Radius.card)
        .overlay(RoundedRectangle(cornerRadius: Radius.card).stroke(Color.bioGold.opacity(0.3), lineWidth: 1))
    }

    @ViewBuilder
    private func lockRow(_ icon: String, _ text: String, show: Bool) -> some View {
        if show {
            HStack(spacing: 10) {
                Image(systemName: icon).font(.caption).foregroundColor(.bioGreen).frame(width: 18)
                Text(text).font(.subheadline).foregroundColor(.primary.opacity(0.85))
                Spacer()
                Image(systemName: "lock.fill").font(.caption2).foregroundColor(.bioGold)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: 6) {
                TagChip(text: "\(point.module.stage.emoji) \(point.module.shortTitle)", color: point.module.color)
                TagChip(text: point.chapter, color: .bioTeal)
                if point.weight >= 3 { TagChip(text: "高频考点", color: .bioDanger) }
            }
            Text(point.title).font(.title2.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.lg)
    }

    private var essenceCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "一句话抓核心", systemImage: "lightbulb", accent: .bioGold)
            Text(point.essence).font(.body).lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(Color.bioGold.opacity(0.08))
        .cornerRadius(Radius.card)
    }

    private var detailCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "深讲 · 讲透", systemImage: "text.book.closed", accent: .bioGreen)
            ForEach(Array(point.detail.enumerated()), id: \.offset) { _, line in
                HStack(alignment: .top, spacing: 8) {
                    Circle().fill(Color.bioGreen).frame(width: 6, height: 6).padding(.top, 7)
                    Text(line).font(.subheadline).lineSpacing(3)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
    }

    private func examCard(_ exam: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Label("高考怎么考", systemImage: "scope").font(AppFont.chip).foregroundColor(.bioBlue)
            Text(exam).font(.subheadline).foregroundColor(.primary.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg).background(Color.bioBlue.opacity(0.08)).cornerRadius(Radius.card)
    }

    private func memCard(_ mem: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "brain.head.profile").font(.caption).foregroundColor(.bioPurple).padding(.top, 2)
            VStack(alignment: .leading, spacing: 2) {
                Text("记忆术").font(AppFont.chip).foregroundColor(.bioPurple)
                Text(mem).font(.subheadline).foregroundColor(.primary.opacity(0.9))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg).background(Color.bioPurple.opacity(0.08)).cornerRadius(Radius.card)
    }

    private var relatedPoints: [KnowledgePoint] { point.related.compactMap { SyllabusData.point(id: $0) } }

    private var relatedCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "关联考点 · 串成网", systemImage: "point.3.connected.trianglepath.dotted", accent: .bioTeal)
            ForEach(relatedPoints) { rp in
                NavigationLink { KnowledgePointDetailView(point: rp) } label: {
                    HStack {
                        Image(systemName: "arrow.turn.down.right").font(.caption).foregroundColor(.bioTeal)
                        Text(rp.title).font(.subheadline).foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right").font(.caption2).foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
    }

    private func processEntry(_ s: ProcessScene) -> some View {
        NavigationLink { ProcessTheaterView(scene: s) } label: {
            HStack(spacing: Spacing.md) {
                Image(systemName: "play.circle.fill").font(.title2).foregroundColor(.bioTeal)
                VStack(alignment: .leading, spacing: 2) {
                    Text("看过程剧场 · \(s.title)").font(AppFont.cardTitle).foregroundColor(.primary)
                    Text("拖时间轴看清每一步").font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
            }
            .padding(Spacing.lg)
            .frame(maxWidth: .infinity)
            .background(Color.bioTeal.opacity(0.1))
            .cornerRadius(Radius.card)
        }
        .buttonStyle(.plain)
    }

    private func errorCard(_ err: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill").font(.caption).foregroundColor(.bioDanger).padding(.top, 2)
            VStack(alignment: .leading, spacing: 2) {
                Text("易错警示").font(AppFont.chip).foregroundColor(.bioDanger)
                Text(err).font(.subheadline).foregroundColor(.primary.opacity(0.9))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(Color.bioDanger.opacity(0.08))
        .cornerRadius(Radius.card)
    }

    // 练一练：做对全部诊断题 → 自动验证掌握
    private var practiceSection: some View {
        let p = questions.progress(for: point.id)
        let verified = questions.isKpVerified(point.id)
        return VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                SectionHeader(title: "练一练 · 做对即掌握", systemImage: "checklist", accent: .bioBlue)
                Text("\(p.done)/\(p.total)").font(AppFont.chip).foregroundColor(verified ? .bioGreen : .secondary)
            }
            Text("按高考权重配题(本考点 \(p.total) 题);全部做对即计入高考覆盖率。")
                .font(.caption2).foregroundColor(.secondary)
            ForEach(kpQuestions) { q in
                QuestionCard(question: q) {
                    if questions.isKpVerified(point.id) { mastery.markMastered(point.id) }
                }
            }
            if verified {
                HStack {
                    Image(systemName: "checkmark.seal.fill").foregroundColor(.bioGreen)
                    Text("已掌握本考点,已计入覆盖率并排期复习").font(AppFont.cardTitle).foregroundColor(.bioGreen)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 12)
                .background(Color.bioGreen.opacity(0.1)).cornerRadius(Radius.inner)
            }
            Button { mistakes.toggleWeak(point.id) } label: {
                Label(mistakes.isWeak(point.id) ? "已标记薄弱（在错题本里）" : "标记为薄弱点",
                      systemImage: mistakes.isWeak(point.id) ? "flag.fill" : "flag")
                    .font(.footnote).foregroundColor(.bioDanger)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, Spacing.sm)
    }

    private var masteryControl: some View {
        let mastered = mastery.state(of: point.id) == .mastered
        return VStack(spacing: Spacing.sm) {
            Button {
                if mastered { mastery.reset(point.id) } else { mastery.markMastered(point.id) }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: mastered ? "checkmark.seal.fill" : "checkmark.circle")
                    Text(mastered ? "已掌握（点按取消）" : "我已掌握这个考点").fontWeight(.bold)
                }
                .font(.headline).foregroundColor(.white)
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(mastered ? Color.bioGreen : Color.bioGreen.opacity(0.9))
                .cornerRadius(Radius.inner)
            }
            .buttonStyle(.plain)
            Button { mistakes.toggleWeak(point.id) } label: {
                Label(mistakes.isWeak(point.id) ? "已标记薄弱（在错题本里）" : "标记为薄弱点",
                      systemImage: mistakes.isWeak(point.id) ? "flag.fill" : "flag")
                    .font(.footnote).foregroundColor(.bioDanger)
            }
            .buttonStyle(.plain).padding(.top, 4)
            Text("标记掌握会计入高考覆盖率并排期复习；标记薄弱会进错题本提醒你回看。")
                .font(.caption2).foregroundColor(.secondary).multilineTextAlignment(.center)
        }
        .padding(.top, Spacing.sm)
    }
}
