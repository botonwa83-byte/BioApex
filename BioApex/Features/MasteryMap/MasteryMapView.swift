import SwiftUI

// MARK: - 掌握地图（脊梁）：高考覆盖率仪表盘 + 考点全图谱（按模块进入）

struct MasteryMapView: View {
    @ObservedObject private var mastery = MasteryManager.shared
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    private var allPoints: [KnowledgePoint] { SyllabusData.all }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    coverageDashboard
                    if !purchase.isUnlocked { premiumBanner }
                    SectionHeader(title: "考点全图谱", systemImage: "square.grid.2x2", accent: .bioGreen)
                    ForEach(BioModule.allCases) { module in
                        moduleCard(module)
                    }
                    Text("把覆盖率拉满，你就拿下了高考的全部分数点。")
                        .font(.caption).foregroundColor(.secondary)
                        .frame(maxWidth: .infinity).padding(.top, Spacing.sm)
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.xxl)
                .readableWidth()
            }
            .background(Color.bioBackground.ignoresSafeArea())
            .navigationTitle("掌握地图")
            .sheet(isPresented: $showPaywall) { PaywallView() }
        }
    }

    // MARK: 覆盖率仪表盘

    private var coverageDashboard: some View {
        let cov = mastery.weightedCoverage(in: allPoints)
        return VStack(spacing: Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("高考考点覆盖率").font(.caption).foregroundColor(.secondary)
                    Text("\(Int(cov * 100))%").font(AppFont.bigStat(40)).foregroundColor(.bioGreen)
                }
                Spacer()
                ZStack {
                    Circle().stroke(Color.bioGreen.opacity(0.15), lineWidth: 10).frame(width: 72, height: 72)
                    Circle().trim(from: 0, to: cov)
                        .stroke(Color.bioGreen, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90)).frame(width: 72, height: 72)
                    Image(systemName: "leaf.fill").foregroundColor(.bioGreen)
                }
            }
            ProgressView(value: cov).tint(.bioGreen)
            HStack {
                Text("已掌握 \(mastery.overallMastered) / \(mastery.overallTotal) 个考点")
                    .font(.caption).foregroundColor(.secondary)
                Spacer()
                Text("学→验→记，逐个掌握").font(.caption2).foregroundColor(.secondary)
            }
        }
        .cardSurface(padding: Spacing.lg)
    }

    // MARK: 解锁横幅

    private var premiumBanner: some View {
        Button { showPaywall = true } label: {
            HStack(spacing: Spacing.md) {
                Image(systemName: "crown.fill").font(.title3).foregroundColor(.white)
                    .frame(width: 44, height: 44).background(Color.white.opacity(0.18))
                    .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
                VStack(alignment: .leading, spacing: 2) {
                    Text("解锁完整版").font(AppFont.cardTitle).foregroundColor(.white)
                    Text("必修2 + 选必全部考点 · 过程剧场 · 神探/实验台,一次买断")
                        .font(.caption2).foregroundColor(.white.opacity(0.9)).lineLimit(2)
                }
                Spacer(minLength: 0)
                Text(purchase.product?.displayPrice ?? "¥22")
                    .font(AppFont.cardTitle).foregroundColor(.white)
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .background(Color.white.opacity(0.22)).clipShape(Capsule())
            }
            .padding(Spacing.lg)
            .background(LinearGradient(colors: [.bioGold, .bioGreen], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(Radius.card)
            .shadow(color: Color.bioGreen.opacity(0.3), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
    }

    // MARK: 模块卡

    private func moduleCard(_ module: BioModule) -> some View {
        let pts = SyllabusData.points(in: module)
        let done = mastery.masteredCount(in: pts)
        let locked = purchase.isModulePremiumLocked(module)
        return NavigationLink {
            ModuleDetailView(module: module)
        } label: {
            HStack(spacing: Spacing.lg) {
                Image(systemName: module.icon).font(.title3)
                    .frame(width: 44, height: 44)
                    .background(module.color.opacity(0.15)).foregroundColor(module.color)
                    .cornerRadius(Radius.inner)
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(module.title).font(AppFont.cardTitle).foregroundColor(.primary)
                        if locked { Image(systemName: "crown.fill").font(.caption2).foregroundColor(.bioGold) }
                    }
                    Text("\(done)/\(pts.count) 考点已掌握").font(.caption).foregroundColor(.secondary)
                    ProgressView(value: pts.isEmpty ? 0 : Double(done) / Double(pts.count)).tint(module.color)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
            }
            .cardSurface(padding: Spacing.lg)
            .opacity(locked ? 0.85 : 1)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 模块详情：按章列出考点

struct ModuleDetailView: View {
    let module: BioModule
    @ObservedObject private var mastery = MasteryManager.shared
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                ForEach(SyllabusData.chapters(in: module), id: \.chapter) { chapter, points in
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        SectionHeader(title: chapter, systemImage: "text.book.closed", accent: module.color)
                        ForEach(points) { p in
                            pointRow(p)
                        }
                    }
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle(module.shortTitle)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    @ViewBuilder
    private func pointRow(_ p: KnowledgePoint) -> some View {
        let locked = purchase.isPointPremiumLocked(p)
        let st = mastery.state(of: p.id)
        // 锁定考点也进详情：先试看一句话钩子，再就地引导解锁（软付费墙）。
        NavigationLink { KnowledgePointDetailView(point: p) } label: { rowLabel(p, locked: locked, state: st) }
            .buttonStyle(.plain)
    }

    private func rowLabel(_ p: KnowledgePoint, locked: Bool, state: MasteryState) -> some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: locked ? "crown.fill" : (state == .mastered ? "checkmark.circle.fill" : "circle"))
                .foregroundColor(locked ? .bioGold : (state == .mastered ? .bioGreen : .secondary))
            VStack(alignment: .leading, spacing: 3) {
                Text(p.title).font(AppFont.cardTitle).foregroundColor(locked ? .secondary : .primary)
                    .multilineTextAlignment(.leading)
                HStack(spacing: 6) {
                    if p.weight >= 3 { TagChip(text: "高频", color: .bioDanger) }
                    if p.processId != nil { TagChip(text: "过程剧场", color: .bioTeal) }
                    if locked { TagChip(text: "完整版", color: .bioGold) }
                }
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .cardSurface(padding: Spacing.md)
    }
}
