import SwiftUI

// MARK: - 考点详情：学（精讲）→ 看过程（如有）→ 标记掌握
// 不堆题海：每个考点用"精讲 + 自评掌握"闭环；带过程的可跳过程剧场。

struct KnowledgePointDetailView: View {
    let point: KnowledgePoint
    @ObservedObject private var mastery = MasteryManager.shared
    @ObservedObject private var mistakes = MistakeManager.shared

    private var scene: ProcessScene? { point.processId.flatMap { ProcessData.scene(id: $0) } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                essenceCard
                if let s = scene { processEntry(s) }
                if let err = point.commonError { errorCard(err) }
                masteryControl
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle(point.title)
        .navigationBarTitleDisplayMode(.inline)
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
            SectionHeader(title: "精讲 · 一句话讲透", systemImage: "lightbulb", accent: .bioGold)
            Text(point.essence).font(.body).lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(Color.bioGold.opacity(0.08))
        .cornerRadius(Radius.card)
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
