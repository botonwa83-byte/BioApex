import SwiftUI

// MARK: - 完整功能解锁付费墙

struct PaywallView: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @Environment(\.dismiss) private var dismiss

    private var priceLabel: String { purchase.product?.displayPrice ?? "¥22" }
    private let summary = PurchaseManager.unlockSummary

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroArea

                statStrip.padding(.horizontal, 24).padding(.top, 18)

                VStack(alignment: .leading, spacing: 14) {
                    benefitRow(icon: "square.grid.2x2.fill", color: .bioGreen,
                               title: "解锁必修2 + 选必全部 \(summary.premiumPoints) 个考点",
                               desc: "遗传进化、稳态调节、生物与环境、生物技术——含 \(summary.premiumQuestions) 道精讲题与采分点")
                    benefitRow(icon: "play.square.stack.fill", color: .bioTeal,
                               title: "解锁全部 \(summary.processes) 个过程剧场",
                               desc: "减数分裂、转录翻译、兴奋传导…拖时间轴看清每一步,断点填空验掌握")
                    benefitRow(icon: "magnifyingglass", color: .bioPurple,
                               title: "遗传神探 \(summary.pedigrees) 例 + 秒算 \(summary.duels) 题全开",
                               desc: "系谱破案练识局、概率秒算双解对决,外加破题之眼 \(summary.challenges) 道压轴巧解,压轴题不再丢分")
                    benefitRow(icon: "testtube.2", color: .bioBlue,
                               title: "探究实验台 \(summary.inquiries) 例 + 稳态回路 \(summary.loops) 条",
                               desc: "实验设计成游戏,负反馈可拨动——高考实验题专项突破")
                    benefitRow(icon: "infinity", color: .bioGold,
                               title: "一次买断,永久使用 · 可家庭共享",
                               desc: "无订阅、无续费,内容持续更新;支持换机恢复购买,一人购买全家(最多 6 人)共享")
                }
                .padding(.horizontal, 24).padding(.top, 22).padding(.bottom, 20)

                Divider().padding(.horizontal, 24)

                VStack(spacing: 6) {
                    Text("免费已开放:初中全部 + 高中必修1全部考点,含光合/呼吸/有丝分裂等过程剧场;掌握地图、易混辨析、智能复习、错题本永久免费。")
                        .font(.footnote).foregroundColor(.secondary).multilineTextAlignment(.center)
                    Text("先把免费考点掌握地图拉满,再解锁全部 →")
                        .font(.footnote).fontWeight(.medium).foregroundColor(.bioGreen)
                }
                .padding(.vertical, 16).padding(.horizontal, 24)

                purchaseButton.padding(.horizontal, 24)

                Button { Task { await purchase.restore() } } label: {
                    Text("恢复购买").font(.footnote).foregroundColor(.secondary).underline()
                }
                .padding(.top, 12).disabled(purchase.isPurchasing)

                if let err = purchase.errorMessage {
                    Text(err).font(.caption).foregroundColor(.bioDanger)
                        .multilineTextAlignment(.center).padding(.horizontal, 24).padding(.top, 8)
                }

                Text("购买即视为同意[用户协议](https://botonwa83-byte.github.io/bioapex/terms.html)与[隐私政策](https://botonwa83-byte.github.io/bioapex/privacy.html)。付款通过 Apple 账户完成,换机后可在「恢复购买」找回。")
                    .font(.system(size: 10)).foregroundColor(.secondary)
                    .tint(.bioGreen)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28).padding(.top, 16).padding(.bottom, 32)
            }
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .onChange(of: purchase.isUnlocked) { unlocked in
            if unlocked { dismiss() }
        }
    }

    private var statStrip: some View {
        HStack(spacing: 0) {
            statItem(number: "\(summary.premiumPoints)", label: "付费考点")
            statDivider
            statItem(number: "\(summary.processes)", label: "过程剧场")
            statDivider
            statItem(number: "\(summary.pedigrees + summary.duels)", label: "遗传专题")
            statDivider
            statItem(number: "\(summary.inquiries + summary.loops)", label: "实验·回路")
        }
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.bioGreen.opacity(0.08)))
    }

    private func statItem(number: String, label: String) -> some View {
        VStack(spacing: 3) {
            Text(number).font(.system(size: 22, weight: .black, design: .rounded)).foregroundColor(.bioGreen)
            Text(label).font(.system(size: 11)).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var statDivider: some View {
        Rectangle().fill(Color.secondary.opacity(0.15)).frame(width: 1, height: 28)
    }

    private var heroArea: some View {
        ZStack {
            LinearGradient(colors: [Color.bioGreen, Color.bioTeal],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack(spacing: 10) {
                Image(systemName: "leaf.fill").font(.system(size: 44)).foregroundColor(.white)
                Text("解锁全部生物考点").font(.system(size: 24, weight: .black, design: .rounded)).foregroundColor(.white)
                Text("覆盖率拉满,高考拿下每一个分数点").font(.subheadline).foregroundColor(.white.opacity(0.9))
            }
            .padding(.vertical, 40)
        }
    }

    private var purchaseButton: some View {
        Button { Task { await purchase.purchase() } } label: {
            HStack(spacing: 10) {
                if purchase.isPurchasing { ProgressView().tint(.white) }
                else { Image(systemName: "lock.open.fill") }
                Text(purchase.isPurchasing ? "处理中…" : "立即解锁  \(priceLabel)").fontWeight(.bold)
            }
            .font(.headline).foregroundColor(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 16)
            .background(LinearGradient(colors: [.bioGreen, .bioTeal], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(16)
            .shadow(color: Color.bioGreen.opacity(0.3), radius: 10, y: 4)
        }
        .disabled(purchase.isPurchasing)
    }

    private func benefitRow(icon: String, color: Color, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(color.opacity(0.15)).frame(width: 38, height: 38)
                Image(systemName: icon).font(.subheadline).foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline).fontWeight(.semibold).foregroundColor(.primary)
                Text(desc).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}
