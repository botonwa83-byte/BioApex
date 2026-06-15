import SwiftUI

// MARK: - 图表曲线分析专项（三看：看轴 → 看点 → 看拐点）

struct GraphAnalysisView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("生物坐标题三看：先看轴(各代表什么)、再看特殊点、后看拐点趋势。")
                    .font(.caption).foregroundColor(.secondary)
                ForEach(GraphData.all) { c in
                    NavigationLink { GraphCaseView(graphCase: c) } label: { card(c) }
                        .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("图表曲线分析").navigationBarTitleDisplayMode(.inline)
    }

    private func card(_ c: GraphCase) -> some View {
        HStack(spacing: Spacing.lg) {
            CurveView(shape: c.shape, color: .bioBlue).frame(width: 56, height: 40)
            VStack(alignment: .leading, spacing: 4) {
                Text(c.title).font(AppFont.cardTitle).foregroundColor(.primary)
                Text("\(c.yAxis) — \(c.xAxis)").font(.caption).foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .cardSurface(padding: Spacing.lg)
    }
}

struct GraphCaseView: View {
    let graphCase: GraphCase
    @State private var picked: Int? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text(graphCase.scenario).font(.subheadline).foregroundColor(.secondary)
                chartCard
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "三看 · 读图要点", systemImage: "eye", accent: .bioBlue)
                    ForEach(Array(graphCase.readingPoints.enumerated()), id: \.offset) { i, pt in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "\(i + 1).circle.fill").foregroundColor(.bioBlue)
                            Text(pt).font(.subheadline)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
                quizCard
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle(graphCase.title).navigationBarTitleDisplayMode(.inline)
    }

    private var chartCard: some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Text(graphCase.yAxis).font(.caption2).foregroundColor(.secondary)
                    .rotationEffect(.degrees(-90)).fixedSize().frame(width: 18)
                CurveView(shape: graphCase.shape, color: .bioGreen).frame(height: 180)
            }
            Text(graphCase.xAxis).font(.caption2).foregroundColor(.secondary)
        }
        .cardSurface(padding: Spacing.lg)
    }

    private var quizCard: some View {
        let q = graphCase.quiz
        return VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(q.prompt).font(AppFont.cardTitle)
            ForEach(q.options.indices, id: \.self) { i in
                Button { if picked == nil { picked = i } } label: {
                    HStack {
                        Text(q.options[i]).font(.subheadline).foregroundColor(.primary)
                        Spacer(minLength: 0)
                        if picked != nil, i == q.answerIndex { Image(systemName: "checkmark.circle.fill").foregroundColor(.bioGreen) }
                        if i == picked, i != q.answerIndex { Image(systemName: "xmark.circle.fill").foregroundColor(.bioDanger) }
                    }
                    .padding(Spacing.md).frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.bioCardSurface).cornerRadius(Radius.inner)
                    .overlay(RoundedRectangle(cornerRadius: Radius.inner).stroke(border(i), lineWidth: 2))
                }
                .buttonStyle(.plain).disabled(picked != nil)
            }
            if picked != nil { Text(q.explanation).font(.caption).foregroundColor(.secondary) }
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
    }

    private func border(_ i: Int) -> Color {
        guard picked != nil else { return .clear }
        if i == graphCase.quiz.answerIndex { return .bioGreen }
        if i == picked { return .bioDanger }
        return .clear
    }
}

// MARK: - 曲线绘制（按形状采样函数，用 Path 画）

struct CurveView: View {
    let shape: GraphShape
    var color: Color = .bioGreen

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            ZStack(alignment: .bottomLeading) {
                // 坐标轴
                Path { p in
                    p.move(to: CGPoint(x: 0, y: 0)); p.addLine(to: CGPoint(x: 0, y: h)); p.addLine(to: CGPoint(x: w, y: h))
                }.stroke(Color.secondary.opacity(0.4), lineWidth: 1.5)
                // 曲线
                Path { p in
                    let n = 60
                    for i in 0...n {
                        let t = CGFloat(i) / CGFloat(n)
                        let y = value(t)
                        let pt = CGPoint(x: t * w, y: h - y * h * 0.92 - h * 0.04)
                        if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
                    }
                }.stroke(color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
            }
        }
    }

    private func value(_ t: CGFloat) -> CGFloat {
        switch shape {
        case .sCurve:     return 1 / (1 + exp(-12 * (t - 0.5)))
        case .bell:       return exp(-pow((t - 0.5) * 4, 2))
        case .saturating: return 1 - exp(-4 * t)
        case .rising:     return t
        case .descending: return 1 - t
        }
    }
}
