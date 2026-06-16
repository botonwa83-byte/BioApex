import StoreKit
import SwiftUI

// MARK: - 完整功能解锁 IAP（StoreKit 2 · 一次性买断）
//
// 产品 ID：com.bioapex.app.full_unlock（¥22 一次性买断，价格在 App Store Connect 配置）
// 内购划线（免费下载 + 内购）：
//   免费档（转化钩子）：初中生物全部考点 + 高中必修1全部考点；过程剧场前 4 个；
//                      细胞图鉴/生命尺度/概念图、易混辨析/智能复习/错题本 永久免费；遗传神探前 2 案。
//   解锁后：必修2 + 选必1/2/3 全部考点、全部过程剧场、遗传神探/秒算/稳态回路/实验台全部、三大题型方法。
// 本地 UserDefaults 缓存即时呈现，启动时 Transaction.currentEntitlements 核验防破解。

final class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()

    let productID = "com.bioapex.app.full_unlock"

    /// 免费档数量（改动需同步 BioApexTests.testFreeTierPolicy）。
    static let freeProcessCount = 4    // 过程剧场前 4 个免费
    static let freeDetectiveCount = 2  // 遗传神探前 2 案免费
    /// 破题之眼免费样本数：每把武器各放出 1 道最易的高考例题（广度免费、纵深付费），见 ChallengeData.freeSampleIds。
    static var freeChallengeCount: Int { ChallengeData.freeSampleIds.count }

    // MARK: 解锁价值统计（数据驱动付费墙：真实数字随内容增长自动更新，无需手改文案）

    struct UnlockSummary {
        let premiumPoints: Int     // 必修2 + 选必 考点数
        let premiumQuestions: Int  // 付费考点配套精讲题/采分点
        let processes: Int         // 过程剧场总数
        let pedigrees: Int         // 遗传神探（系谱破案）
        let duels: Int             // 遗传秒算（双解对决）
        let loops: Int             // 稳态回路
        let inquiries: Int         // 探究实验
        let challenges: Int        // 破题之眼（压轴巧解）
    }

    /// 解锁后可获得的内容统计；付费墙直接读取，内容增量后自动反映。
    static var unlockSummary: UnlockSummary {
        let premiumPoints = SyllabusData.all.filter { !$0.module.isFree }
        let premiumIds = Set(premiumPoints.map { $0.id })
        let premiumQuestions = QuestionData.all.filter { premiumIds.contains($0.kpId) }.count
        return UnlockSummary(
            premiumPoints: premiumPoints.count,
            premiumQuestions: premiumQuestions,
            processes: ProcessData.all.count,
            pedigrees: GeneticsData.pedigrees.count,
            duels: GeneticsData.duels.count,
            loops: HomeostasisData.all.count,
            inquiries: InquiryData.all.count,
            challenges: ChallengeData.all.count)
    }

    @Published private(set) var isUnlocked = false
    @Published private(set) var product: Product?
    @Published private(set) var isPurchasing = false
    @Published private(set) var errorMessage: String?

    private let storageKey = "bioapex_full_unlocked"

    private init() {
        isUnlocked = UserDefaults.standard.bool(forKey: storageKey)
        Task {
            await loadProduct()
            await refreshEntitlements()
        }
    }

    // MARK: 免费档判定

    /// 考点是否被付费锁住：初中 + 必修1 永久免费，其余需解锁。
    func isPointPremiumLocked(_ point: KnowledgePoint) -> Bool {
        guard !isUnlocked else { return false }
        return !point.module.isFree
    }

    func isModulePremiumLocked(_ module: BioModule) -> Bool {
        guard !isUnlocked else { return false }
        return !module.isFree
    }

    func isProcessPremiumLocked(index: Int) -> Bool {
        guard !isUnlocked else { return false }
        return index >= Self.freeProcessCount
    }

    func isDetectivePremiumLocked(index: Int) -> Bool {
        guard !isUnlocked else { return false }
        return index >= Self.freeDetectiveCount
    }

    /// 破题之眼按"每武器免费第 1 道"判定：免费样本之外（含全部竞赛题与难度 5）均锁定。
    func isChallengePremiumLocked(_ problem: ChallengeProblem) -> Bool {
        guard !isUnlocked else { return false }
        return !ChallengeData.freeSampleIds.contains(problem.id)
    }

    // MARK: StoreKit

    @MainActor
    func loadProduct() async {
        do {
            let products = try await Product.products(for: [productID])
            product = products.first
        } catch {
            // 沙盒未配置时静默失败，价格降级显示
        }
    }

    @MainActor
    func purchase() async {
        guard let product else {
            errorMessage = "获取产品信息失败，请检查网络后重试"
            return
        }
        isPurchasing = true
        errorMessage = nil
        defer { isPurchasing = false }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                unlock()
            case .userCancelled:
                break
            case .pending:
                errorMessage = "购买待处理（可能需要家长确认），完成后将自动解锁"
            @unknown default:
                break
            }
        } catch {
            errorMessage = "购买失败：\(error.localizedDescription)"
        }
    }

    @MainActor
    func restore() async {
        isPurchasing = true
        errorMessage = nil
        defer { isPurchasing = false }
        do {
            try await AppStore.sync()
            await refreshEntitlements()
            if !isUnlocked { errorMessage = "未找到购买记录" }
        } catch {
            errorMessage = "恢复失败：\(error.localizedDescription)"
        }
    }

    func refreshEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let tx) = result,
               tx.productID == productID,
               tx.revocationDate == nil {
                await MainActor.run { unlock() }
                return
            }
        }
    }

    @MainActor
    private func unlock() {
        isUnlocked = true
        UserDefaults.standard.set(true, forKey: storageKey)
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error): throw error
        case .verified(let value): return value
        }
    }
}
