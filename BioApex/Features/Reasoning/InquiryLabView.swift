import SwiftUI

// MARK: - 探究实验台：变量 → 对照 → 预测，逐步闯关

struct InquiryLabView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("高考实验题的核心是设计:找准变量、设好对照、预测结果。")
                    .font(.caption).foregroundColor(.secondary)
                ForEach(InquiryData.all) { c in
                    NavigationLink { InquiryCaseView(inquiry: c) } label: { caseCard(c) }
                        .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("探究实验台")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func caseCard(_ c: InquiryCase) -> some View {
        HStack(spacing: Spacing.lg) {
            Image(systemName: "testtube.2").font(.title3).frame(width: 40, height: 40)
                .background(Color.bioBlue.opacity(0.15)).foregroundColor(.bioBlue).cornerRadius(Radius.inner)
            VStack(alignment: .leading, spacing: 4) {
                Text(c.title).font(AppFont.cardTitle).foregroundColor(.primary)
                Text("\(c.steps.count) 步设计闯关").font(.caption).foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .cardSurface(padding: Spacing.lg)
    }
}

struct InquiryCaseView: View {
    let inquiry: InquiryCase
    @State private var step = 0
    @State private var picked: Int? = nil
    @State private var passed: Set<Int> = []

    private var current: InquiryStep { inquiry.steps[step] }
    private var finished: Bool { passed.count == inquiry.steps.count }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                questionCard
                if finished {
                    principleCard
                } else {
                    progressBar
                    stepCard
                }
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle(inquiry.title).navigationBarTitleDisplayMode(.inline)
    }

    private var questionCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("探究问题", systemImage: "questionmark.circle").font(AppFont.chip).foregroundColor(.bioBlue)
            Text(inquiry.question).font(.subheadline).fontWeight(.medium)
            Text(inquiry.background).font(.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
    }

    private var progressBar: some View {
        HStack(spacing: 6) {
            ForEach(inquiry.steps.indices, id: \.self) { i in
                Capsule().fill(passed.contains(i) ? Color.bioBlue : (i == step ? Color.bioBlue.opacity(0.4) : Color.secondary.opacity(0.2)))
                    .frame(height: 6)
            }
        }
    }

    private var stepCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("第 \(step + 1)/\(inquiry.steps.count) 步").font(AppFont.chip).foregroundColor(.bioBlue)
            Text(current.prompt).font(AppFont.cardTitle)
            ForEach(current.options.indices, id: \.self) { i in optionButton(i) }
            if let picked, picked == current.answerIndex {
                Text(current.explanation).font(.caption).foregroundColor(.bioGreen)
                Button { advance() } label: {
                    Text(step == inquiry.steps.count - 1 ? "完成设计" : "下一步").font(AppFont.cardTitle)
                        .frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background(Color.bioBlue).foregroundColor(.white).cornerRadius(Radius.inner)
                }
                .buttonStyle(.plain)
            } else if let picked, picked != current.answerIndex {
                Text(current.explanation).font(.caption).foregroundColor(.bioDanger)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
    }

    private func optionButton(_ i: Int) -> some View {
        let correct = i == current.answerIndex
        var border: Color = .clear
        if picked != nil { if correct { border = .bioGreen } else if i == picked { border = .bioDanger } }
        return Button { if picked == nil || picked != current.answerIndex { picked = i } } label: {
            HStack {
                Text(current.options[i]).font(.subheadline).foregroundColor(.primary).multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                if picked != nil, correct { Image(systemName: "checkmark.circle.fill").foregroundColor(.bioGreen) }
            }
            .padding(Spacing.md).frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.bioCardSurface).cornerRadius(Radius.inner)
            .overlay(RoundedRectangle(cornerRadius: Radius.inner).stroke(border, lineWidth: 2))
        }
        .buttonStyle(.plain)
    }

    private func advance() {
        passed.insert(step)
        if step < inquiry.steps.count - 1 { withAnimation { step += 1; picked = nil } }
        else { withAnimation { _ = passed.insert(step) } }
    }

    private var principleCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack { Text("🏆 设计完成").font(.headline); Spacer() }
            Label("实验设计原则", systemImage: "checkmark.seal.fill").font(AppFont.cardTitle).foregroundColor(.bioGreen)
            Text(inquiry.principle).font(.subheadline).lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg).background(Color.bioGreen.opacity(0.1)).cornerRadius(Radius.card)
    }
}
