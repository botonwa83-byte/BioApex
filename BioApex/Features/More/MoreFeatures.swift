import SwiftUI

// MARK: - 易混辨析对决

struct ConfusionListView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("生物易混点全科第一——左右对比看清，再做辨析判断。")
                    .font(.caption).foregroundColor(.secondary)
                ForEach(ConfusionData.all) { pair in
                    NavigationLink { ConfusionDetailView(pair: pair) } label: { card(pair) }
                        .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("易混辨析").navigationBarTitleDisplayMode(.inline)
    }

    private func card(_ p: ConfusionPair) -> some View {
        HStack(spacing: Spacing.lg) {
            Image(systemName: "arrow.left.arrow.right.circle.fill").font(.title3).frame(width: 40, height: 40)
                .background(Color.bioPurple.opacity(0.15)).foregroundColor(.bioPurple).cornerRadius(Radius.inner)
            VStack(alignment: .leading, spacing: 4) {
                Text(p.title).font(AppFont.cardTitle).foregroundColor(.primary)
                Text("\(p.rows.count) 维度对比 · \(p.quizzes.count) 题辨析").font(.caption).foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .cardSurface(padding: Spacing.lg)
    }
}

struct ConfusionDetailView: View {
    let pair: ConfusionPair
    @ObservedObject private var mistakes = MistakeManager.shared
    @State private var qIndex = 0
    @State private var picked: Bool? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                comparisonTable
                quizArea
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle(pair.title).navigationBarTitleDisplayMode(.inline)
    }

    private var comparisonTable: some View {
        VStack(spacing: 0) {
            HStack {
                Text("维度").font(AppFont.chip).foregroundColor(.secondary).frame(width: 76, alignment: .leading)
                Text(pair.leftName).font(AppFont.chip).foregroundColor(.bioGreen).frame(maxWidth: .infinity)
                Text(pair.rightName).font(AppFont.chip).foregroundColor(.bioBlue).frame(maxWidth: .infinity)
            }
            .padding(.vertical, Spacing.sm)
            Divider()
            ForEach(pair.rows) { row in
                HStack(alignment: .top) {
                    Text(row.dimension).font(.caption2).foregroundColor(.secondary).frame(width: 76, alignment: .leading)
                    Text(row.left).font(.caption).frame(maxWidth: .infinity, alignment: .leading)
                    Text(row.right).font(.caption).frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, Spacing.sm)
                Divider()
            }
        }
        .cardSurface(padding: Spacing.lg)
    }

    @ViewBuilder
    private var quizArea: some View {
        if qIndex < pair.quizzes.count {
            let q = pair.quizzes[qIndex]
            VStack(alignment: .leading, spacing: Spacing.md) {
                Text("辨析 \(qIndex + 1)/\(pair.quizzes.count)").font(AppFont.chip).foregroundColor(.bioPurple)
                Text(q.statement).font(.subheadline).fontWeight(.medium)
                HStack(spacing: Spacing.md) {
                    choiceButton(q, isLeft: true, label: pair.leftName)
                    choiceButton(q, isLeft: false, label: pair.rightName)
                }
                if let picked {
                    Text(q.explanation).font(.caption)
                        .foregroundColor(picked == q.answerIsLeft ? .bioGreen : .bioDanger)
                    Button { next() } label: {
                        Text(qIndex == pair.quizzes.count - 1 ? "完成" : "下一题").font(AppFont.cardTitle)
                            .frame(maxWidth: .infinity).padding(.vertical, 12)
                            .background(Color.bioPurple).foregroundColor(.white).cornerRadius(Radius.inner)
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
        } else {
            HStack {
                Image(systemName: "checkmark.seal.fill").foregroundColor(.bioGreen)
                Text("这组辨析完成！").font(AppFont.cardTitle)
            }
            .frame(maxWidth: .infinity).cardSurface(padding: Spacing.lg)
        }
    }

    private func choiceButton(_ q: ConfusionQuiz, isLeft: Bool, label: String) -> some View {
        var border: Color = .clear
        if let picked {
            if isLeft == q.answerIsLeft { border = .bioGreen }
            else if picked == isLeft { border = .bioDanger }
        }
        return Button {
            guard picked == nil else { return }
            picked = isLeft
            if isLeft != q.answerIsLeft { mistakes.addConfusion(pair.id) }
        } label: {
            Text(label).font(AppFont.cardTitle).frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(Color.bioCardSurface).cornerRadius(Radius.inner)
                .overlay(RoundedRectangle(cornerRadius: Radius.inner).stroke(border == .clear ? Color.secondary.opacity(0.2) : border, lineWidth: 2))
        }
        .buttonStyle(.plain)
    }

    private func next() { withAnimation { qIndex += 1; picked = nil } }
}

// MARK: - 智能复习

struct ReviewView: View {
    @ObservedObject private var scheduler = ReviewScheduler.shared
    private var due: [KnowledgePoint] {
        let ids = Set(scheduler.dueItems().map(\.id))
        return SyllabusData.all.filter { ids.contains($0.id) }
    }

    var body: some View {
        Group {
            if scheduler.items.isEmpty {
                ContentUnavailableViewCompat(title: "复习计划空空如也", systemImage: "brain.head.profile",
                    description: "在掌握地图里标记掌握的考点，会按 1/3/7/15/30/60 天自动排期复习。")
            } else if due.isEmpty {
                ContentUnavailableViewCompat(title: "今天没有到期的复习", systemImage: "checkmark.circle",
                    description: "已排期 \(scheduler.items.count) 个考点，继续保持 🎉")
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        Text("今日待复习 · \(due.count)").font(AppFont.sectionTitle)
                        ForEach(due) { p in reviewCard(p) }
                    }
                    .padding(Spacing.lg).readableWidth()
                }
                .background(Color.bioBackground.ignoresSafeArea())
            }
        }
        .navigationTitle("智能复习").navigationBarTitleDisplayMode(.inline)
    }

    private func reviewCard(_ p: KnowledgePoint) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(p.title).font(AppFont.cardTitle)
            Text(p.essence).font(.caption).foregroundColor(.secondary)
            HStack(spacing: Spacing.md) {
                Button { scheduler.review(p.id, remembered: false) } label: {
                    Label("忘了", systemImage: "xmark").font(AppFont.chip).frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(Color.bioDanger.opacity(0.15)).foregroundColor(.bioDanger).cornerRadius(Radius.inner)
                }.buttonStyle(.plain)
                Button { scheduler.review(p.id, remembered: true) } label: {
                    Label("记得", systemImage: "checkmark").font(AppFont.chip).frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(Color.bioGreen).foregroundColor(.white).cornerRadius(Radius.inner)
                }.buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
    }
}

// MARK: - 错题/薄弱本

struct MistakeBookView: View {
    @ObservedObject private var mistakes = MistakeManager.shared

    private var wrongPairs: [ConfusionPair] { ConfusionData.all.filter { mistakes.wrongConfusion.contains($0.id) } }
    private var weak: [KnowledgePoint] { SyllabusData.all.filter { mistakes.weakPoints.contains($0.id) } }

    var body: some View {
        Group {
            if mistakes.totalCount == 0 {
                ContentUnavailableViewCompat(title: "还没有错题/薄弱点", systemImage: "checkmark.seal",
                    description: "辨析答错会自动收录；在考点详情点「标记薄弱」也会进来。")
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        if !weak.isEmpty {
                            SectionHeader(title: "薄弱考点 · \(weak.count)", systemImage: "flag", accent: .bioDanger)
                            ForEach(weak) { p in
                                NavigationLink { KnowledgePointDetailView(point: p) } label: {
                                    rowLabel(p.title, p.module.shortTitle)
                                }.buttonStyle(.plain)
                            }
                        }
                        if !wrongPairs.isEmpty {
                            SectionHeader(title: "辨析错题 · \(wrongPairs.count)", systemImage: "arrow.left.arrow.right", accent: .bioPurple)
                            ForEach(wrongPairs) { p in
                                NavigationLink { ConfusionDetailView(pair: p) } label: {
                                    rowLabel(p.title, "重做")
                                }.buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(Spacing.lg).readableWidth()
                }
                .background(Color.bioBackground.ignoresSafeArea())
            }
        }
        .navigationTitle("错题本").navigationBarTitleDisplayMode(.inline)
    }

    private func rowLabel(_ title: String, _ tag: String) -> some View {
        HStack {
            Text(title).font(AppFont.cardTitle).foregroundColor(.primary)
            Spacer()
            TagChip(text: tag, color: .bioTeal)
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .cardSurface(padding: Spacing.md)
    }
}

// MARK: - 学情诊断

struct DiagnosisView: View {
    @ObservedObject private var mastery = MasteryManager.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                overall
                SectionHeader(title: "各模块掌握度（弱在前）", systemImage: "chart.bar.xaxis", accent: .bioBlue)
                ForEach(sortedModules(), id: \.self) { m in moduleRow(m) }
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("学情诊断").navigationBarTitleDisplayMode(.inline)
    }

    private func sortedModules() -> [BioModule] {
        BioModule.allCases.sorted { mastery.coverage(in: SyllabusData.points(in: $0)) < mastery.coverage(in: SyllabusData.points(in: $1)) }
    }

    private var overall: some View {
        let cov = mastery.weightedCoverage(in: SyllabusData.all)
        return VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("总体高考覆盖率").font(.caption).foregroundColor(.secondary)
            Text("\(Int(cov * 100))%").font(AppFont.bigStat(36)).foregroundColor(.bioGreen)
            ProgressView(value: cov).tint(.bioGreen)
            Text("已掌握 \(mastery.overallMastered)/\(mastery.overallTotal) 个考点").font(.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
    }

    private func moduleRow(_ m: BioModule) -> some View {
        let pts = SyllabusData.points(in: m)
        let cov = mastery.coverage(in: pts)
        return VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(m.title).font(.subheadline).lineLimit(1)
                Spacer()
                Text("\(Int(cov * 100))%").font(AppFont.chip).foregroundColor(accColor(cov))
            }
            ProgressView(value: cov).tint(accColor(cov))
        }
        .cardSurface(padding: Spacing.md)
    }

    private func accColor(_ a: Double) -> Color { a >= 0.8 ? .bioGreen : (a >= 0.4 ? .bioGold : .bioDanger) }
}
