import SwiftUI

// MARK: - 稳态回路模拟器：拨动变量,看负反馈如何把它拉回稳态

struct FeedbackSimulatorView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("把变量推高或压低,看身体如何通过负反馈拉回稳态。")
                    .font(.caption).foregroundColor(.secondary)
                ForEach(HomeostasisData.all) { loop in
                    NavigationLink { FeedbackLoopView(loop: loop) } label: { loopCard(loop) }
                        .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("稳态回路")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func loopCard(_ loop: FeedbackLoop) -> some View {
        HStack(spacing: Spacing.lg) {
            Image(systemName: "arrow.triangle.2.circlepath").font(.title3).frame(width: 40, height: 40)
                .background(Color.bioTeal.opacity(0.15)).foregroundColor(.bioTeal).cornerRadius(Radius.inner)
            VStack(alignment: .leading, spacing: 4) {
                Text(loop.name).font(AppFont.cardTitle).foregroundColor(.primary)
                Text(loop.setPoint).font(.caption).foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .cardSurface(padding: Spacing.lg)
    }
}

struct FeedbackLoopView: View {
    let loop: FeedbackLoop
    enum Status { case normal, high, low }
    @State private var status: Status = .normal

    private var response: FeedbackResponse? {
        switch status { case .high: return loop.high; case .low: return loop.low; case .normal: return nil }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                gauge
                controls
                if let r = response { responseCard(r) } else { idleCard }
                noteCard
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle(loop.name).navigationBarTitleDisplayMode(.inline)
    }

    // 变量指示条
    private var gauge: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text(loop.variable).font(AppFont.cardTitle)
                Spacer()
                Text(statusLabel).font(AppFont.chip).foregroundColor(statusColor)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.secondary.opacity(0.15)).frame(height: 14)
                    // 正常区间高亮
                    Capsule().fill(Color.bioGreen.opacity(0.25))
                        .frame(width: geo.size.width * 0.34, height: 14)
                        .offset(x: geo.size.width * 0.33)
                    Circle().fill(statusColor).frame(width: 22, height: 22)
                        .offset(x: max(0, min(geo.size.width - 22, geo.size.width * markerPos - 11)))
                        .animation(.easeInOut(duration: 0.5), value: status)
                }
            }
            .frame(height: 22)
            Text(loop.setPoint).font(.caption2).foregroundColor(.secondary)
        }
        .cardSurface(padding: Spacing.lg)
    }

    private var controls: some View {
        HStack(spacing: Spacing.md) {
            ctrlButton("偏低", "arrow.down", .bioBlue) { withAnimation { status = .low } }
            ctrlButton("回稳态", "equal", .bioGreen) { withAnimation { status = .normal } }
            ctrlButton("偏高", "arrow.up", .bioDanger) { withAnimation { status = .high } }
        }
    }

    private func ctrlButton(_ title: String, _ icon: String, _ color: Color, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon).font(AppFont.chip)
                .frame(maxWidth: .infinity).padding(.vertical, 12)
                .background(color.opacity(0.15)).foregroundColor(color).cornerRadius(Radius.inner)
        }
        .buttonStyle(.plain)
    }

    private func responseCard(_ r: FeedbackResponse) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack { Image(systemName: "bolt.heart.fill").foregroundColor(statusColor); Text(r.trigger).font(AppFont.cardTitle) }
            ForEach(Array(r.chain.enumerated()), id: \.offset) { i, s in
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Image(systemName: "\(i + 1).circle.fill").foregroundColor(.bioTeal)
                    Text(s).font(.subheadline)
                }
            }
            HStack(spacing: 6) {
                Image(systemName: "checkmark.seal.fill").foregroundColor(.bioGreen)
                Text(r.result).font(.subheadline).fontWeight(.semibold).foregroundColor(.bioGreen)
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
    }

    private var idleCard: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: "hand.tap.fill").foregroundColor(.bioTeal)
            Text("点上方「偏高」或「偏低」,看身体如何把 \(loop.variable) 拉回正常。")
                .font(.subheadline).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
    }

    private var noteCard: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: "info.circle").font(.caption).foregroundColor(.bioTeal).padding(.top, 1)
            Text(loop.note).font(.caption).foregroundColor(.bioTeal)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg).background(Color.bioTeal.opacity(0.08)).cornerRadius(Radius.card)
    }

    private var markerPos: Double { switch status { case .low: return 0.12; case .normal: return 0.5; case .high: return 0.88 } }
    private var statusLabel: String { switch status { case .low: return "偏低"; case .normal: return "稳态"; case .high: return "偏高" } }
    private var statusColor: Color { switch status { case .low: return .bioBlue; case .normal: return .bioGreen; case .high: return .bioDanger } }
}
