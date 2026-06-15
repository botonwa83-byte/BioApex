import SwiftUI

// MARK: - 推理场 Tab：遗传神探 / 遗传秒算 / 探究实验台（P4 阶段填充，先占位入口）

struct ReasoningView: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("生物里唯一的强逻辑+强计算——把遗传和实验做成游戏。")
                        .font(.caption).foregroundColor(.secondary)

                    // 遗传神探:内部按案件分免费/付费(前 2 案免费)
                    entry(icon: "magnifyingglass", color: .bioPurple,
                          title: "遗传神探 · 系谱破案",
                          subtitle: "逐条揭线索 → 判显隐、定常/X", locked: false) { PedigreeDetectiveView() }
                    // 以下为完整版内容
                    entry(icon: "bolt.fill", color: .bioGold,
                          title: "遗传秒算 · 双解对决",
                          subtitle: "棋盘法（慢）vs 分离定律拆解相乘（秒）", locked: !purchase.isUnlocked) { GeneticsDuelView() }
                    entry(icon: "testtube.2", color: .bioBlue,
                          title: "探究实验台",
                          subtitle: "选变量、设对照、预测结果——实验设计成游戏", locked: !purchase.isUnlocked) { InquiryLabView() }
                    entry(icon: "arrow.triangle.2.circlepath", color: .bioTeal,
                          title: "稳态回路模拟器",
                          subtitle: "拨动血糖/体温，看负反馈如何回拉", locked: !purchase.isUnlocked) { FeedbackSimulatorView() }
                }
                .padding(Spacing.lg)
                .readableWidth()
            }
            .background(Color.bioBackground.ignoresSafeArea())
            .navigationTitle("推理场")
            .sheet(isPresented: $showPaywall) { PaywallView() }
        }
    }

    @ViewBuilder
    private func entry<D: View>(icon: String, color: Color, title: String, subtitle: String,
                                locked: Bool, @ViewBuilder dest: @escaping () -> D) -> some View {
        Group {
            if locked {
                Button { showPaywall = true } label: { entryLabel(icon: icon, color: color, title: title, subtitle: subtitle, locked: true) }
            } else {
                NavigationLink { dest() } label: { entryLabel(icon: icon, color: color, title: title, subtitle: subtitle, locked: false) }
            }
        }
        .buttonStyle(.plain)
    }

    private func entryLabel(icon: String, color: Color, title: String, subtitle: String, locked: Bool) -> some View {
        HStack(spacing: Spacing.lg) {
            Image(systemName: locked ? "crown.fill" : icon).font(.title2).frame(width: 48, height: 48)
                .background((locked ? Color.bioGold : color).opacity(0.15))
                .foregroundColor(locked ? .bioGold : color).cornerRadius(Radius.inner)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(AppFont.cardTitle).foregroundColor(locked ? .secondary : .primary)
                Text(subtitle).font(.caption).foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
            if locked { TagChip(text: "完整版", color: .bioGold) }
            else { Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary) }
        }
        .cardSurface(padding: Spacing.lg).opacity(locked ? 0.85 : 1)
    }
}
