import SwiftUI

// MARK: - 生命的尺度：从生物大分子缩放到生物圈（生命系统的结构层次）

struct LifeScaleView: View {
    private let levels = ScaleData.all
    @State private var index = 2   // 默认从"细胞"（最基本生命系统）开始

    private var level: ScaleLevel { levels[index] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("拖滑块或点按上下，从分子一路放大到生物圈。")
                    .font(.caption).foregroundColor(.secondary)

                ladder
                levelCard

                HStack(spacing: Spacing.md) {
                    navButton("缩小", "minus.magnifyingglass", disabled: index == 0) {
                        if index > 0 { withAnimation { index -= 1 } }
                    }
                    navButton("放大", "plus.magnifyingglass", disabled: index == levels.count - 1) {
                        if index < levels.count - 1 { withAnimation { index += 1 } }
                    }
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("生命的尺度")
        .navigationBarTitleDisplayMode(.inline)
    }

    // 层次阶梯
    private var ladder: some View {
        VStack(spacing: 0) {
            ForEach(levels.reversed()) { lv in
                Button { withAnimation { index = lv.order } } label: {
                    HStack(spacing: Spacing.md) {
                        Circle()
                            .fill(lv.order == index ? Color.bioGreen : Color.secondary.opacity(0.25))
                            .frame(width: 10, height: 10)
                        Text(lv.name)
                            .font(lv.order == index ? AppFont.cardTitle : .subheadline)
                            .foregroundColor(lv.order == index ? .bioGreen : .secondary)
                        if !lv.isLifeSystem {
                            Text("非生命系统层次").font(.caption2).foregroundColor(.secondary.opacity(0.7))
                        }
                        Spacer()
                        Text(lv.scale).font(.caption2).foregroundColor(.secondary)
                    }
                    .padding(.vertical, 6)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(Spacing.lg)
        .background(Color.bioCardSurface).cornerRadius(Radius.card).cardShadow()
    }

    private var levelCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text(level.name).font(.title2.bold()).foregroundColor(.bioGreen)
                Spacer()
                TagChip(text: level.scale, color: .bioTeal)
            }
            Text(level.summary).font(.subheadline).lineSpacing(4)
            HStack(spacing: 6) {
                Image(systemName: "sparkles").font(.caption2).foregroundColor(.bioGold)
                Text("例：\(level.example)").font(.caption).foregroundColor(.secondary)
            }
            if let note = level.note {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "info.circle").font(.caption2).foregroundColor(.bioBlue).padding(.top, 1)
                    Text(note).font(.caption).foregroundColor(.bioBlue)
                }
                .padding(Spacing.sm).frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.bioBlue.opacity(0.08)).cornerRadius(Radius.inner)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.lg)
    }

    private func navButton(_ title: String, _ icon: String, disabled: Bool, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(AppFont.cardTitle).frame(maxWidth: .infinity).padding(.vertical, 12)
                .background(disabled ? Color.secondary.opacity(0.12) : Color.bioGreen)
                .foregroundColor(disabled ? .secondary : .white).cornerRadius(Radius.inner)
        }
        .buttonStyle(.plain).disabled(disabled)
    }
}
