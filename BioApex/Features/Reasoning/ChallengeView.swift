import SwiftUI

// MARK: - 破题之眼：高考压轴 + 竞赛巧解（天花板模块，前 2 题免费）

struct ChallengeView: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("高考压轴 × 生物竞赛——别硬刚，先识局，一招巧解。")
                    .font(.caption).foregroundColor(.secondary)
                ForEach(Array(ChallengeData.all.enumerated()), id: \.element.id) { index, p in
                    row(p, locked: purchase.isChallengePremiumLocked(index: index))
                }
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("破题之眼").navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    @ViewBuilder
    private func row(_ p: ChallengeProblem, locked: Bool) -> some View {
        Group {
            if locked {
                Button { showPaywall = true } label: { label(p, locked: true) }
            } else {
                NavigationLink { ChallengeDetailView(problem: p) } label: { label(p, locked: false) }
            }
        }
        .buttonStyle(.plain)
    }

    private func label(_ p: ChallengeProblem, locked: Bool) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: 6) {
                TagChip(text: p.kind.label, color: p.kind.color)
                TagChip(text: p.topic, color: .bioTeal)
                Spacer()
                Text(String(repeating: "🔥", count: p.difficulty)).font(.caption2)
                if locked { Image(systemName: "crown.fill").font(.caption2).foregroundColor(.bioGold) }
            }
            Text(p.title).font(AppFont.cardTitle).foregroundColor(locked ? .secondary : .primary)
            HStack(spacing: 6) {
                Image(systemName: p.weapon.icon).font(.caption2).foregroundColor(.bioGreen)
                Text("巧解：\(p.weapon.name)").font(.caption).foregroundColor(.bioGreen)
                if locked { TagChip(text: "完整版", color: .bioGold) }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.lg).opacity(locked ? 0.85 : 1)
    }
}

struct ChallengeDetailView: View {
    let problem: ChallengeProblem
    @State private var showSolution = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                HStack(spacing: 6) {
                    TagChip(text: problem.kind.label, color: problem.kind.color)
                    TagChip(text: problem.topic, color: .bioTeal)
                    TagChip(text: problem.weapon.name, color: .bioGreen)
                    Spacer()
                    Text(String(repeating: "🔥", count: problem.difficulty)).font(.caption)
                }
                Text(problem.content).font(.body).lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)

                trapCard

                if !showSolution {
                    Button { withAnimation { showSolution = true } } label: {
                        Label("揭晓巧解", systemImage: "eye").font(AppFont.cardTitle)
                            .frame(maxWidth: .infinity).padding(.vertical, 14)
                            .background(LinearGradient(colors: [.bioGreen, .bioTeal], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white).cornerRadius(Radius.inner)
                    }
                    .buttonStyle(.plain)
                } else {
                    insightCard
                    stepsCard
                    answerCard
                    takeawayCard
                }
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("破题之眼").navigationBarTitleDisplayMode(.inline)
    }

    private var trapCard: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill").font(.caption).foregroundColor(.bioDanger).padding(.top, 2)
            VStack(alignment: .leading, spacing: 2) {
                Text("常规思路的困境").font(AppFont.chip).foregroundColor(.bioDanger)
                Text(problem.trap).font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg).background(Color.bioDanger.opacity(0.08)).cornerRadius(Radius.card)
    }

    private var insightCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Label("识局 · 巧解关键", systemImage: problem.weapon.icon).font(AppFont.cardTitle).foregroundColor(.bioGreen)
            Text(problem.keyInsight).font(.subheadline).lineSpacing(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg).background(Color.bioGreen.opacity(0.1)).cornerRadius(Radius.card)
    }

    private var stepsCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "巧解步骤", systemImage: "list.number", accent: .bioTeal)
            ForEach(Array(problem.steps.enumerated()), id: \.offset) { i, s in
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Text("\(i + 1)").font(AppFont.chip).frame(width: 20, height: 20)
                        .background(Circle().fill(Color.bioTeal.opacity(0.15))).foregroundColor(.bioTeal)
                    Text(s).font(.subheadline)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
    }

    private var answerCard: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.seal.fill").foregroundColor(.bioGreen)
            Text(problem.answer).font(AppFont.cardTitle).foregroundColor(.bioGreen)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg).background(Color.bioGreen.opacity(0.1)).cornerRadius(Radius.card)
    }

    private var takeawayCard: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "key.fill").font(.caption).foregroundColor(.bioGold).padding(.top, 2)
            VStack(alignment: .leading, spacing: 2) {
                Text("方法迁移").font(AppFont.chip).foregroundColor(.bioGold)
                Text(problem.takeaway).font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg).background(Color.bioGold.opacity(0.08)).cornerRadius(Radius.card)
    }
}
