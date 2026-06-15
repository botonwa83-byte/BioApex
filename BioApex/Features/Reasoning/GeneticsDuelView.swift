import SwiftUI

// MARK: - 遗传秒算：双解对决列表 + 详情

struct GeneticsDuelView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("同一道遗传题：常规棋盘法（慢）vs 分离定律拆解相乘（秒）。")
                    .font(.caption).foregroundColor(.secondary)
                ForEach(GeneticsData.duels) { c in
                    NavigationLink { GeneticsDuelDetailView(geneticsCase: c) } label: { caseCard(c) }
                        .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("遗传秒算")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func caseCard(_ c: GeneticsCase) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Image(systemName: "bolt.fill").foregroundColor(.bioGold)
                Text(c.title).font(AppFont.cardTitle)
                Spacer()
                TagChip(text: String(format: "快 %.0f 倍", c.duo.timeRatio), color: .bioGold)
            }
            Text(c.content).font(.caption).foregroundColor(.secondary).lineLimit(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.lg)
    }
}

struct GeneticsDuelDetailView: View {
    let geneticsCase: GeneticsCase
    @State private var picked: Int? = nil
    @State private var showStandard = false
    @State private var showShortcut = true
    @State private var showPlain = false

    private var duo: DuoSolution { geneticsCase.duo }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text(geneticsCase.content).font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)

                ForEach(geneticsCase.options.indices, id: \.self) { i in optionButton(i) }

                if picked != nil {
                    timeBar
                    pathCard(title: duo.shortcut.title, path: duo.shortcut, accent: .bioGold, expanded: $showShortcut)
                    pathCard(title: duo.standard.title, path: duo.standard, accent: .bioBlue, expanded: $showStandard)
                    if !duo.principle.isEmpty { principleCard }
                    insightCard
                    plainCard
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("遗传秒算").navigationBarTitleDisplayMode(.inline)
    }

    private func optionButton(_ i: Int) -> some View {
        let label = ["A", "B", "C", "D"][min(i, 3)]
        let revealed = picked != nil
        let correct = i == geneticsCase.answerIndex
        var border: Color = .clear
        if revealed { if correct { border = .bioGreen } else if i == picked { border = .bioDanger } }
        return Button { if picked == nil { picked = i } } label: {
            HStack(spacing: Spacing.md) {
                Text(label).font(AppFont.cardTitle).frame(width: 26, height: 26)
                    .background(Circle().fill(Color.bioGreen.opacity(0.12)))
                Text(geneticsCase.options[i]).font(.subheadline)
                Spacer(minLength: 0)
                if revealed, correct { Image(systemName: "checkmark.circle.fill").foregroundColor(.bioGreen) }
            }
            .foregroundColor(.primary).padding(Spacing.lg).frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.bioCardSurface).cornerRadius(Radius.inner)
            .overlay(RoundedRectangle(cornerRadius: Radius.inner).stroke(border, lineWidth: 2))
        }
        .buttonStyle(.plain)
    }

    private var timeBar: some View {
        HStack {
            Image(systemName: "stopwatch").foregroundColor(.bioGold)
            Text(String(format: "常规 %.1f 分 → 秒算 %.1f 分,快 %.0f 倍",
                        duo.standard.minutes, duo.shortcut.minutes, duo.timeRatio))
                .font(AppFont.chip).foregroundColor(.bioGold)
            Spacer()
        }
        .padding(Spacing.md).background(Color.bioGold.opacity(0.1)).cornerRadius(Radius.inner)
    }

    private func pathCard(title: String, path: SolvePath, accent: Color, expanded: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Button { withAnimation { expanded.wrappedValue.toggle() } } label: {
                HStack {
                    Text(title).font(AppFont.cardTitle).foregroundColor(.primary)
                    Spacer()
                    Image(systemName: expanded.wrappedValue ? "chevron.up" : "chevron.down").font(.caption).foregroundColor(.secondary)
                }
            }
            .buttonStyle(.plain)
            if expanded.wrappedValue {
                ForEach(path.steps.indices, id: \.self) { i in
                    HStack(alignment: .top, spacing: Spacing.sm) {
                        Text("\(i + 1)").font(AppFont.chip).frame(width: 18, height: 18)
                            .background(Circle().fill(accent.opacity(0.15))).foregroundColor(accent)
                        Text(path.steps[i]).font(.subheadline)
                    }
                }
            }
        }
        .cardSurface(padding: Spacing.lg)
    }

    private var principleCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Label("为什么能这么秒 · 原理", systemImage: "lightbulb.max.fill").font(AppFont.cardTitle).foregroundColor(.bioGreen)
            Text(duo.principle).font(.subheadline).lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg).background(Color.bioGreen.opacity(0.1)).cornerRadius(Radius.card)
    }

    private var insightCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Label("一句话记住", systemImage: "key.fill").font(AppFont.cardTitle).foregroundColor(.bioGold)
            Text(duo.keyInsight).font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
    }

    private var plainCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Button { withAnimation { showPlain.toggle() } } label: {
                HStack { Text("🗣 说人话").font(AppFont.cardTitle); Spacer()
                    Image(systemName: showPlain ? "chevron.up" : "chevron.down").font(.caption) }
                .foregroundColor(.primary)
            }
            .buttonStyle(.plain)
            if showPlain { Text(duo.plainTalk).font(.subheadline).foregroundColor(.primary.opacity(0.85)) }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg).background(Color.bioTeal.opacity(0.08)).cornerRadius(Radius.card)
    }
}
