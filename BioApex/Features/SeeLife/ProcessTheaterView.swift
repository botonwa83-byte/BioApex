import SwiftUI

// MARK: - 过程剧场播放器（生物镇馆之宝）
// 拖时间轴看每一步：发生什么 / 消耗 / 产生；关键步骤断点填空，答对才继续。

struct ProcessTheaterView: View {
    let scene: ProcessScene

    @State private var step = 0
    @State private var answered: Set<Int> = []   // 已通过断点的步骤下标
    @State private var picked: Int? = nil

    private var current: ProcessStage { scene.stages[step] }
    private var gateBlocked: Bool {
        // 当前步有 quiz 且未答对，则不能前进
        current.quiz != nil && !answered.contains(step)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                infoHeader
                timeline
                stageCard
                if let quiz = current.quiz, !answered.contains(step) {
                    quizCard(quiz)
                }
                navButtons
                if step == scene.stages.count - 1 {
                    examHookCard
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle(scene.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var infoHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(scene.subtitle).font(.subheadline).foregroundColor(.secondary)
            HStack(spacing: 6) {
                Image(systemName: "mappin.and.ellipse").font(.caption2).foregroundColor(.bioTeal)
                Text("场所：\(scene.location)").font(.caption).foregroundColor(.bioTeal)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: 时间轴

    private var timeline: some View {
        HStack(spacing: 6) {
            ForEach(scene.stages.indices, id: \.self) { i in
                Capsule()
                    .fill(i <= step ? Color.bioTeal : Color.secondary.opacity(0.2))
                    .frame(height: 6)
                    .onTapGesture {
                        // 只能跳到已解锁（不越过未答的断点）的步骤
                        if i <= step { withAnimation { step = i; picked = nil } }
                    }
            }
        }
        .overlay(alignment: .trailing) {
            Text("\(step + 1)/\(scene.stages.count)").font(AppFont.chip).foregroundColor(.secondary)
                .offset(y: -16)
        }
        .padding(.top, 8)
    }

    private var stageCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text("第 \(step + 1) 步").font(AppFont.chip).foregroundColor(.bioTeal)
                Text(current.name).font(AppFont.cardTitle)
            }
            Text(current.detail).font(.subheadline).lineSpacing(4)
            HStack(spacing: Spacing.md) {
                if let c = current.consumes { ioPill("消耗", c, .bioDanger) }
                if let p = current.produces { ioPill("产生", p, .bioGreen) }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(padding: Spacing.lg)
    }

    private func ioPill(_ label: String, _ value: String, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.caption2).foregroundColor(.secondary)
            Text(value).font(.caption).fontWeight(.semibold).foregroundColor(color)
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(color.opacity(0.1)).cornerRadius(Radius.chip)
    }

    // MARK: 断点填空

    private func quizCard(_ quiz: ProcessQuiz) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: 6) {
                Image(systemName: "questionmark.circle.fill").foregroundColor(.bioGold)
                Text(quiz.prompt).font(AppFont.cardTitle)
            }
            ForEach(quiz.options.indices, id: \.self) { i in
                Button { pick(i, quiz: quiz) } label: {
                    HStack {
                        Text(quiz.options[i]).font(.subheadline).multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                        if picked == i {
                            Image(systemName: i == quiz.answerIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(i == quiz.answerIndex ? .bioGreen : .bioDanger)
                        }
                    }
                    .foregroundColor(.primary).padding(Spacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.bioCardSurface).cornerRadius(Radius.inner)
                    .overlay(RoundedRectangle(cornerRadius: Radius.inner)
                        .stroke(borderColor(i, quiz: quiz), lineWidth: 2))
                }
                .buttonStyle(.plain)
            }
            if let picked, picked != quiz.answerIndex {
                Text(quiz.explanation).font(.caption).foregroundColor(.bioDanger)
            }
        }
        .padding(Spacing.lg)
        .background(Color.bioGold.opacity(0.06)).cornerRadius(Radius.card)
    }

    private func borderColor(_ i: Int, quiz: ProcessQuiz) -> Color {
        guard let picked else { return .clear }
        if i == quiz.answerIndex && (picked == quiz.answerIndex || picked == i) { return .bioGreen }
        if i == picked && picked != quiz.answerIndex { return .bioDanger }
        return .clear
    }

    private func pick(_ i: Int, quiz: ProcessQuiz) {
        picked = i
        if i == quiz.answerIndex { withAnimation { answered.insert(step) } }
    }

    // MARK: 导航

    private var navButtons: some View {
        HStack(spacing: Spacing.md) {
            Button { withAnimation { step = max(0, step - 1); picked = nil } } label: {
                Label("上一步", systemImage: "chevron.left")
                    .font(AppFont.cardTitle).frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(Color.secondary.opacity(0.12)).foregroundColor(.primary).cornerRadius(Radius.inner)
            }
            .buttonStyle(.plain).disabled(step == 0)

            Button { withAnimation { step = min(scene.stages.count - 1, step + 1); picked = nil } } label: {
                Label(step == scene.stages.count - 1 ? "已到结尾" : "下一步", systemImage: "chevron.right")
                    .font(AppFont.cardTitle).frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(gateBlocked || step == scene.stages.count - 1 ? Color.secondary.opacity(0.12) : Color.bioTeal)
                    .foregroundColor(gateBlocked || step == scene.stages.count - 1 ? .secondary : .white)
                    .cornerRadius(Radius.inner)
            }
            .buttonStyle(.plain).disabled(gateBlocked || step == scene.stages.count - 1)
        }
    }

    private var examHookCard: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: "target").font(.caption).foregroundColor(.bioGreen).padding(.top, 2)
            VStack(alignment: .leading, spacing: 2) {
                Text("钩回考点").font(AppFont.chip).foregroundColor(.bioGreen)
                Text(scene.examHook).font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg).background(Color.bioGreen.opacity(0.1)).cornerRadius(Radius.card)
    }
}
