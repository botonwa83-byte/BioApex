import SwiftUI

// MARK: - 遗传神探：系谱破案（逐条揭线索 → 判定遗传方式）

struct PedigreeDetectiveView: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("把遗传系谱当案子破：逐条揭线索，锁定遗传方式。揭得越少越准，越像神探。")
                    .font(.caption).foregroundColor(.secondary)
                ForEach(Array(GeneticsData.pedigrees.enumerated()), id: \.element.id) { index, c in
                    caseRow(c, locked: purchase.isDetectivePremiumLocked(index: index))
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("遗传神探")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    @ViewBuilder
    private func caseRow(_ c: PedigreeCase, locked: Bool) -> some View {
        // 锁定案件也进详情：试看案情 + 第 1 条线索，再就地引导解锁。
        NavigationLink { PedigreeCaseView(pedigree: c, previewLocked: locked) } label: { caseLabel(c, locked: locked) }
            .buttonStyle(.plain)
    }

    private func caseLabel(_ c: PedigreeCase, locked: Bool) -> some View {
        HStack(spacing: Spacing.lg) {
            Image(systemName: locked ? "crown.fill" : "magnifyingglass").font(.title3)
                .frame(width: 40, height: 40)
                .background((locked ? Color.bioGold : Color.bioPurple).opacity(0.15))
                .foregroundColor(locked ? .bioGold : .bioPurple).cornerRadius(Radius.inner)
            VStack(alignment: .leading, spacing: 4) {
                Text(c.title).font(AppFont.cardTitle).foregroundColor(locked ? .secondary : .primary)
                HStack(spacing: 6) {
                    TagChip(text: "\(c.clues.count) 条线索", color: .bioPurple)
                    if locked { TagChip(text: "完整版", color: .bioGold) }
                }
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .cardSurface(padding: Spacing.lg).opacity(locked ? 0.85 : 1)
    }
}

struct PedigreeCaseView: View {
    let pedigree: PedigreeCase
    var previewLocked: Bool = false
    @State private var revealed = 1
    @State private var picked: Int? = nil
    @State private var solved = false
    @State private var showPaywall = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                scenarioCard
                if previewLocked {
                    SectionHeader(title: "线索 · 1/\(pedigree.clues.count)", systemImage: "doc.text.magnifyingglass", accent: .bioPurple)
                    if let first = pedigree.clues.first { clueCard(first) }
                    unlockGate
                } else {
                    SectionHeader(title: "线索 · \(revealed)/\(pedigree.clues.count)", systemImage: "doc.text.magnifyingglass", accent: .bioPurple)
                    ForEach(pedigree.clues.prefix(revealed)) { clue in clueCard(clue) }
                    if revealed < pedigree.clues.count && !solved {
                        Button { withAnimation { revealed += 1 } } label: {
                            Label("揭开下一条线索", systemImage: "hand.point.right")
                                .font(AppFont.cardTitle).frame(maxWidth: .infinity).padding(Spacing.md)
                                .background(Color.bioPurple.opacity(0.12)).foregroundColor(.bioPurple).cornerRadius(Radius.inner)
                        }
                        .buttonStyle(.plain)
                    }
                    SectionHeader(title: "锁定遗传方式", systemImage: "checkmark.seal", accent: .bioGreen)
                    ForEach(pedigree.options.indices, id: \.self) { i in optionButton(i) }
                    if solved { verdictCard }
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle(pedigree.title).navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    private var unlockGate: some View {
        VStack(spacing: Spacing.sm) {
            HStack(spacing: 6) {
                Image(systemName: "eye.fill").font(.caption).foregroundColor(.bioGold)
                Text("免费试看案情与第 1 条线索 · 全案 \(pedigree.clues.count) 条").font(AppFont.chip).foregroundColor(.bioGold)
            }
            Button { showPaywall = true } label: {
                HStack(spacing: 8) {
                    Image(systemName: "lock.open.fill")
                    Text("解锁完整破案").fontWeight(.bold)
                }
                .font(.headline).foregroundColor(.white)
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(LinearGradient(colors: [.bioPurple, .bioBlue], startPoint: .leading, endPoint: .trailing))
                .cornerRadius(Radius.inner)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.lg)
        .background(Color.bioGold.opacity(0.08)).cornerRadius(Radius.card)
        .overlay(RoundedRectangle(cornerRadius: Radius.card).stroke(Color.bioGold.opacity(0.3), lineWidth: 1))
    }

    private var scenarioCard: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            Image(systemName: "person.2.badge.gearshape").foregroundColor(.bioPurple)
            Text(pedigree.scenario).font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
    }

    private func clueCard(_ clue: PedigreeClue) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "doc.text.magnifyingglass").font(.caption).foregroundColor(.bioGold).padding(.top, 2)
                Text(clue.text).font(.subheadline)
            }
            if solved {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "brain").font(.caption).foregroundColor(.bioPurple).padding(.top, 2)
                    Text(clue.deduction).font(.caption).foregroundColor(.bioPurple)
                }
                .padding(Spacing.sm).frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.bioPurple.opacity(0.08)).cornerRadius(Radius.inner)
            }
        }
        .cardSurface(padding: Spacing.lg)
    }

    private func optionButton(_ i: Int) -> some View {
        let correct = i == pedigree.answerIndex
        var border: Color = .clear
        if picked != nil { if correct { border = .bioGreen } else if i == picked { border = .bioDanger } }
        return Button {
            guard !solved else { return }
            picked = i
            if correct { withAnimation { solved = true } }
        } label: {
            HStack {
                Text(pedigree.options[i]).font(.subheadline).foregroundColor(.primary)
                Spacer(minLength: 0)
                if picked != nil, correct { Image(systemName: "checkmark.circle.fill").foregroundColor(.bioGreen) }
                if i == picked, !correct { Image(systemName: "xmark.circle.fill").foregroundColor(.bioDanger) }
            }
            .padding(Spacing.lg).frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.bioCardSurface).cornerRadius(Radius.inner)
            .overlay(RoundedRectangle(cornerRadius: Radius.inner).stroke(border, lineWidth: 2))
        }
        .buttonStyle(.plain)
    }

    private var verdictCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack { Text("🎉 破案").font(.headline); Spacer()
                Text("用 \(revealed) 条线索").font(.caption).foregroundColor(.secondary) }
            Text(pedigree.verdict).font(.subheadline)
            Text("提示：上方每条线索已展开推理价值，回看一遍完整排除链。")
                .font(.caption).foregroundColor(.bioPurple)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg).background(Color.bioGreen.opacity(0.1)).cornerRadius(Radius.card)
    }
}
