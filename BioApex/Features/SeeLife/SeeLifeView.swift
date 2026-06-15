import SwiftUI

// MARK: - 看见生命 Tab：过程剧场（闪光点）+ 细胞图鉴/生命尺度（占位）

struct SeeLifeView: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("生物是「动」的——把抽象过程拖出来看清每一步。")
                        .font(.caption).foregroundColor(.secondary)

                    entryCard(icon: "circle.hexagongrid.fill", color: .bioGreen,
                              title: "细胞图鉴", subtitle: "可交互细胞，点细胞器看结构与功能") {
                        CellAtlasView()
                    }
                    entryCard(icon: "arrow.up.left.and.down.right.magnifyingglass", color: .bioBlue,
                              title: "生命的尺度", subtitle: "从生物大分子到生物圈，一镜到底") {
                        LifeScaleView()
                    }
                    entryCard(icon: "point.3.connected.trianglepath.dotted", color: .bioPurple,
                              title: "概念关联网", subtitle: "按生命观念把考点串成网") {
                        ConceptMapView()
                    }

                    SectionHeader(title: "过程剧场", systemImage: "play.square.stack", accent: .bioTeal)
                    ForEach(Array(ProcessData.all.enumerated()), id: \.element.id) { index, scene in
                        processRow(scene, locked: purchase.isProcessPremiumLocked(index: index))
                    }
                }
                .padding(Spacing.lg)
                .readableWidth()
            }
            .background(Color.bioBackground.ignoresSafeArea())
            .navigationTitle("看见生命")
            .sheet(isPresented: $showPaywall) { PaywallView() }
        }
    }

    private func entryCard<D: View>(icon: String, color: Color, title: String, subtitle: String,
                                    @ViewBuilder dest: @escaping () -> D) -> some View {
        NavigationLink { dest() } label: {
            HStack(spacing: Spacing.lg) {
                Image(systemName: icon).font(.title2).frame(width: 48, height: 48)
                    .background(color.opacity(0.15)).foregroundColor(color).cornerRadius(Radius.inner)
                VStack(alignment: .leading, spacing: 3) {
                    Text(title).font(AppFont.cardTitle).foregroundColor(.primary)
                    Text(subtitle).font(.caption).foregroundColor(.secondary)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
            }
            .cardSurface(padding: Spacing.lg)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func processRow(_ scene: ProcessScene, locked: Bool) -> some View {
        Group {
            if locked {
                Button { showPaywall = true } label: { processLabel(scene, locked: true) }
            } else {
                NavigationLink { ProcessTheaterView(scene: scene) } label: { processLabel(scene, locked: false) }
            }
        }
        .buttonStyle(.plain)
    }

    private func processLabel(_ scene: ProcessScene, locked: Bool) -> some View {
        HStack(spacing: Spacing.lg) {
            Image(systemName: locked ? "crown.fill" : "play.circle.fill").font(.title2)
                .frame(width: 44, height: 44)
                .background((locked ? Color.bioGold : Color.bioTeal).opacity(0.15))
                .foregroundColor(locked ? .bioGold : .bioTeal).cornerRadius(Radius.inner)
            VStack(alignment: .leading, spacing: 3) {
                Text(scene.title).font(AppFont.cardTitle).foregroundColor(locked ? .secondary : .primary)
                Text(scene.subtitle).font(.caption).foregroundColor(.secondary).lineLimit(1)
                HStack(spacing: 6) {
                    TagChip(text: "\(scene.stages.count) 步", color: .bioTeal)
                    if locked { TagChip(text: "完整版", color: .bioGold) }
                }
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .cardSurface(padding: Spacing.lg)
        .opacity(locked ? 0.85 : 1)
    }
}
