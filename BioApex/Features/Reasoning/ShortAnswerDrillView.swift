import SwiftUI

// MARK: - 简答采分专项（生物提分第一杠杆：会做但答不到采分点）
// 汇总全库简答题,集中练"规范表述 + 踩采分点"。内容随题库增量自动变多。

struct ShortAnswerDrillView: View {
    private var items: [Question] { QuestionData.all.filter { $0.type == .shortAnswer } }

    var body: some View {
        Group {
            if items.isEmpty {
                ContentUnavailableViewCompat(title: "简答题正在补充", systemImage: "text.append",
                    description: "随着各考点配题,这里会汇总所有简答题供你集中练采分点。")
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        Text("大题失分多在「会做但答不到点」。先自己组织答案,再逐条对照采分点。")
                            .font(.caption).foregroundColor(.secondary)
                        ForEach(items) { q in
                            VStack(alignment: .leading, spacing: 4) {
                                if let kp = SyllabusData.point(id: q.kpId) {
                                    Text(kp.title).font(.caption2).foregroundColor(.bioTeal)
                                }
                                QuestionCard(question: q) { }
                            }
                        }
                    }
                    .padding(Spacing.lg).readableWidth()
                }
                .background(Color.bioBackground.ignoresSafeArea())
            }
        }
        .navigationTitle("简答采分训练").navigationBarTitleDisplayMode(.inline)
    }
}
