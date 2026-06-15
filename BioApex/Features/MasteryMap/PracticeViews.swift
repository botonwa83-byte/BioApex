import SwiftUI

// MARK: - 练习题卡（选择 / 简答采分），做对回调用于验证掌握

struct QuestionCard: View {
    let question: Question
    var onCorrect: () -> Void
    @ObservedObject private var qm = QuestionManager.shared

    @State private var picked: Int? = nil
    @State private var revealed = false

    private var alreadyCorrect: Bool { qm.isCorrect(question.id) }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: 6) {
                TagChip(text: question.type.label, color: question.type == .choice ? .bioBlue : .bioPurple)
                if alreadyCorrect {
                    HStack(spacing: 3) { Image(systemName: "checkmark.seal.fill"); Text("已掌握") }
                        .font(AppFont.chip).foregroundColor(.bioGreen)
                }
                Spacer()
            }
            Text(question.stem).font(.subheadline).fontWeight(.medium)

            if question.type == .choice { choiceBody } else { shortBody }
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
        .onAppear { if alreadyCorrect { revealed = true } }
    }

    // MARK: 选择题
    private var choiceBody: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            ForEach(question.options.indices, id: \.self) { i in
                Button { choose(i) } label: {
                    HStack {
                        Text(question.options[i]).font(.subheadline).foregroundColor(.primary).multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                        if shown, i == question.answerIndex { Image(systemName: "checkmark.circle.fill").foregroundColor(.bioGreen) }
                        if i == picked, i != question.answerIndex { Image(systemName: "xmark.circle.fill").foregroundColor(.bioDanger) }
                    }
                    .padding(Spacing.md).frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.bioCardSurface).cornerRadius(Radius.inner)
                    .overlay(RoundedRectangle(cornerRadius: Radius.inner).stroke(border(i), lineWidth: 2))
                }
                .buttonStyle(.plain).disabled(alreadyCorrect)
            }
            if shown { Text(question.explanation).font(.caption).foregroundColor(.secondary) }
        }
    }

    private var shown: Bool { picked != nil || alreadyCorrect }
    private func border(_ i: Int) -> Color {
        guard shown else { return .clear }
        if i == question.answerIndex { return .bioGreen }
        if i == picked { return .bioDanger }
        return .clear
    }
    private func choose(_ i: Int) {
        guard picked == nil, !alreadyCorrect else { return }
        picked = i
        if i == question.answerIndex { qm.markCorrect(question.id); onCorrect() }
    }

    // MARK: 简答题（采分点自评对照）
    private var shortBody: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            if !revealed {
                Text("先在脑中/草稿纸组织完整答案，再翻开对采分点 👇").font(.caption).foregroundColor(.secondary)
                Button { withAnimation { revealed = true } } label: {
                    Text("翻开标准答案 + 采分点").font(AppFont.cardTitle)
                        .frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background(Color.bioPurple).foregroundColor(.white).cornerRadius(Radius.inner)
                }
                .buttonStyle(.plain)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Label("标准答案", systemImage: "checkmark.circle").font(AppFont.chip).foregroundColor(.bioGreen)
                    Text(question.modelAnswer).font(.subheadline).lineSpacing(3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Spacing.md).background(Color.bioGreen.opacity(0.08)).cornerRadius(Radius.inner)
                VStack(alignment: .leading, spacing: 4) {
                    Text("采分点（对照你的答案）").font(AppFont.chip).foregroundColor(.bioGold)
                    ForEach(Array(question.scorePoints.enumerated()), id: \.offset) { _, pt in
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "checkmark.square").font(.caption).foregroundColor(.bioGold).padding(.top, 1)
                            Text(pt).font(.caption).foregroundColor(.primary.opacity(0.9))
                        }
                    }
                }
                if !alreadyCorrect {
                    Button { qm.markCorrect(question.id); onCorrect() } label: {
                        Text("我已对照掌握这题").font(AppFont.cardTitle)
                            .frame(maxWidth: .infinity).padding(.vertical, 12)
                            .background(Color.bioGreen).foregroundColor(.white).cornerRadius(Radius.inner)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
