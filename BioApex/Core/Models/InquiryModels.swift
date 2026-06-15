import Foundation

// MARK: - 探究实验台（科学探究：变量 / 对照 / 预测）

struct InquiryStep: Identifiable, Codable {
    let id: String
    let prompt: String       // 决策点（如：本实验的自变量是？）
    let options: [String]
    let answerIndex: Int
    let explanation: String
}

struct InquiryCase: Identifiable, Codable {
    let id: String
    let title: String
    let question: String     // 探究问题
    let background: String
    let steps: [InquiryStep] // 变量识别 / 对照设置 / 结果预测
    let principle: String    // 实验设计原则小结
}

// MARK: - 稳态回路（负反馈调节）

struct FeedbackResponse: Codable {
    let trigger: String      // 触发（如：血糖偏高）
    let chain: [String]      // 调节步骤（有序）
    let result: String       // 回到稳态
}

struct FeedbackLoop: Identifiable, Codable {
    let id: String
    let name: String         // 血糖调节
    let variable: String     // 血糖
    let setPoint: String     // 正常范围
    let regulator: String    // 调节方式/中枢
    let high: FeedbackResponse
    let low: FeedbackResponse
    let note: String
}
