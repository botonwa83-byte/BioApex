import SwiftUI

// MARK: - 解题武器库（家族标配）：何时用 → 怎么用 → 看例题 / 去哪练

struct WeaponLibraryView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("每把武器都是一套可迁移的方法：先学会识局（什么题该用它），再学步骤，最后看它怎么破压轴题。")
                    .font(.caption).foregroundColor(.secondary)
                ForEach(WeaponData.all) { guide in
                    NavigationLink { WeaponDetailView(guide: guide) } label: { card(guide) }
                        .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("解题武器库").navigationBarTitleDisplayMode(.inline)
    }

    private func card(_ g: WeaponGuide) -> some View {
        HStack(spacing: Spacing.lg) {
            Image(systemName: g.weapon.icon).font(.title3).frame(width: 44, height: 44)
                .background(Color.bioGreen.opacity(0.15)).foregroundColor(.bioGreen).cornerRadius(Radius.inner)
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(g.weapon.name).font(AppFont.cardTitle).foregroundColor(.primary)
                    if g.weapon.isOlympiad { TagChip(text: "竞赛", color: .bioPurple) }
                }
                Text(g.tagline).font(.caption).foregroundColor(.bioGreen)
                Text(g.weapon.insight).font(.caption2).foregroundColor(.secondary).lineLimit(2)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .cardSurface(padding: Spacing.lg)
    }
}

struct WeaponDetailView: View {
    let guide: WeaponGuide
    private var example: ChallengeProblem? { guide.exampleChallengeId.flatMap { ChallengeData.problem(id: $0) } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                section("何时亮出它 · 识局", "scope", .bioGold, items: guide.whenToUse, numbered: false)
                section("怎么用 · 方法步骤", "list.number", .bioGreen, items: guide.steps, numbered: true)
                if let ex = example {
                    SectionHeader(title: "看它破一道压轴题", systemImage: "eye", accent: .bioPurple)
                    NavigationLink { ChallengeDetailView(problem: ex) } label: { exampleCard(ex) }
                        .buttonStyle(.plain)
                }
                if let hint = guide.practiceHint {
                    HStack(spacing: 8) {
                        Image(systemName: "figure.run").foregroundColor(.bioBlue)
                        Text(hint).font(.subheadline).foregroundColor(.bioBlue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Spacing.lg).background(Color.bioBlue.opacity(0.08)).cornerRadius(Radius.card)
                }
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle(guide.weapon.name).navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.md) {
                Image(systemName: guide.weapon.icon).font(.title).frame(width: 54, height: 54)
                    .background(Color.bioGreen.opacity(0.15)).foregroundColor(.bioGreen).cornerRadius(Radius.inner)
                VStack(alignment: .leading, spacing: 4) {
                    Text(guide.weapon.name).font(.title2.bold())
                    Text(guide.tagline).font(.subheadline).foregroundColor(.bioGreen)
                }
            }
            Text(guide.weapon.insight).font(.subheadline).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
    }

    private func section(_ title: String, _ icon: String, _ accent: Color, items: [String], numbered: Bool) -> some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: title, systemImage: icon, accent: accent)
            ForEach(Array(items.enumerated()), id: \.offset) { i, s in
                HStack(alignment: .top, spacing: Spacing.sm) {
                    if numbered {
                        Text("\(i + 1)").font(AppFont.chip).frame(width: 20, height: 20)
                            .background(Circle().fill(accent.opacity(0.15))).foregroundColor(accent)
                    } else {
                        Image(systemName: "eye").font(.caption).foregroundColor(accent).padding(.top, 2)
                    }
                    Text(s).font(.subheadline)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
    }

    private func exampleCard(_ ex: ChallengeProblem) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                TagChip(text: ex.kind.label, color: ex.kind.color)
                Spacer()
                Text(String(repeating: "🔥", count: ex.difficulty)).font(.caption2)
            }
            Text(ex.title).font(AppFont.cardTitle)
            Text(ex.keyInsight).font(.caption).foregroundColor(.bioPurple).lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg).background(Color.bioPurple.opacity(0.08)).cornerRadius(Radius.card)
    }
}
