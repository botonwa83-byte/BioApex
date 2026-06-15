import SwiftUI

// MARK: - 启动广告页：品牌 → 卖点 → 数据 → 开发者 → 版权 → 进入（对标 Apex 家族）

struct PromoView: View {
    var onEnter: () -> Void

    @State private var appeared = false
    @State private var glow = false

    private let features: [(icon: String, color: Color, title: String, desc: String)] = [
        ("play.square.stack.fill", .bioTeal, "过程剧场", "光合/呼吸/分裂/转录翻译——拖时间轴看清每一步,断点填空"),
        ("chart.bar.doc.horizontal.fill", .bioGreen, "考点全图谱", "覆盖初高中全部考点,覆盖率拉满=拿下高考每个分数点"),
        ("magnifyingglass", .bioPurple, "遗传神探", "系谱破案+概率秒算,把遗传压轴做成游戏"),
        ("arrow.triangle.2.circlepath", .bioBlue, "稳态回路", "拨动血糖/体温,看负反馈如何回拉——系统思维"),
        ("brain.head.profile", .bioGold, "易混辨析+智能复习", "有丝vs减数等易混点专项,艾宾浩斯间隔复习"),
    ]

    private var bg: some View {
        LinearGradient(colors: [Color(UIColor(hex6: 0x0B1A12)),
                                Color(UIColor(hex6: 0x123524)),
                                Color(UIColor(hex6: 0x0B1A12))],
                       startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }

    var body: some View {
        ZStack {
            bg
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.bioGreen, .bioTeal], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 96, height: 96)
                                .shadow(color: Color.bioGreen.opacity(glow ? 0.7 : 0.3), radius: glow ? 26 : 12)
                            Image(systemName: "leaf.fill").font(.system(size: 44, weight: .bold)).foregroundColor(.white)
                        }
                        Text("BIO APEX")
                            .font(.system(size: 30, weight: .heavy, design: .rounded)).tracking(2)
                            .foregroundStyle(LinearGradient(colors: [.bioGreen, .bioTeal], startPoint: .leading, endPoint: .trailing))
                        Text("看 见 生 命 · 考 点 登 顶")
                            .font(.system(size: 14, weight: .medium)).tracking(2).foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.top, 48)

                    VStack(spacing: 10) {
                        Text("装上 BioApex,把初高中生物考点逐个掌握")
                            .font(.system(size: 18, weight: .bold)).multilineTextAlignment(.center).foregroundColor(.white)
                        Text("不刷题海,只把每个考点教懂、验会、记牢\n覆盖率拉满,高考拿下每一个分数点")
                            .font(.system(size: 13)).multilineTextAlignment(.center).foregroundColor(.white.opacity(0.6)).lineSpacing(4)
                    }
                    .padding(.top, 28).padding(.horizontal, 24)

                    VStack(spacing: 12) {
                        ForEach(Array(features.enumerated()), id: \.offset) { _, f in
                            HStack(spacing: 14) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12).fill(f.color.opacity(0.20)).frame(width: 46, height: 46)
                                    Image(systemName: f.icon).font(.system(size: 20, weight: .semibold)).foregroundColor(f.color)
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(f.title).font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                                    Text(f.desc).font(.system(size: 13)).foregroundColor(.white.opacity(0.65)).lineSpacing(2).fixedSize(horizontal: false, vertical: true)
                                }
                                Spacer(minLength: 0)
                            }
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.06)))
                        }
                    }
                    .padding(.top, 28).padding(.horizontal, 24)

                    HStack(spacing: 0) {
                        stat("\(SyllabusData.all.count)+", "覆盖考点")
                        statDivider
                        stat("\(ProcessData.all.count)", "过程剧场")
                        statDivider
                        stat("6", "教材模块")
                    }
                    .padding(.vertical, 18).padding(.horizontal, 24)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.05)))
                    .padding(.top, 24).padding(.horizontal, 24)

                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle().fill(LinearGradient(colors: [.bioGreen, .bioTeal], startPoint: .top, endPoint: .bottom)).frame(width: 44, height: 44)
                                Text("K").font(.system(size: 22, weight: .heavy)).foregroundColor(.white)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Top King").font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                                Text("独立开发者 / 教育科技探索者").font(.system(size: 12)).foregroundColor(.white.opacity(0.6))
                            }
                            Spacer()
                        }
                        Text("专注教育类 App。BioApex 把生物从「背不完」变成「逐个掌握」——过程剧场让你看见生命运转,考点地图让你不漏一分,遗传神探让难题变游戏。")
                            .font(.system(size: 13)).foregroundColor(.white.opacity(0.65)).lineSpacing(3)
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.06)))
                    .padding(.top, 24).padding(.horizontal, 24)

                    VStack(spacing: 4) {
                        Text("BioApex · 生命登顶  v1.0.0").font(.system(size: 12)).foregroundColor(.white.opacity(0.5))
                        Text("© 2026 Top King. All rights reserved.").font(.system(size: 11)).foregroundColor(.white.opacity(0.35))
                    }
                    .padding(.top, 22).padding(.bottom, 120)
                }
                .frame(maxWidth: 600).frame(maxWidth: .infinity)
                .opacity(appeared ? 1 : 0).offset(y: appeared ? 0 : 24)
            }

            VStack {
                Spacer()
                Button(action: onEnter) {
                    HStack(spacing: 8) {
                        Text("开 启 生 命 登 顶 之 旅").fontWeight(.bold).tracking(1)
                        Image(systemName: "arrow.right")
                    }
                    .font(.system(size: 17, weight: .bold)).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                    .background(LinearGradient(colors: [.bioGreen, .bioTeal], startPoint: .leading, endPoint: .trailing),
                                in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.bioGreen.opacity(0.45), radius: 14, y: 4)
                }
                .frame(maxWidth: 600 - 48).padding(.horizontal, 24).padding(.bottom, 20)
                .background(
                    LinearGradient(colors: [Color(UIColor(hex6: 0x0B1A12)).opacity(0), Color(UIColor(hex6: 0x0B1A12))], startPoint: .top, endPoint: .bottom)
                        .frame(height: 120).allowsHitTesting(false), alignment: .bottom
                )
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) { appeared = true }
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) { glow = true }
        }
    }

    private func stat(_ n: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(n).font(.system(size: 24, weight: .heavy, design: .rounded)).foregroundColor(.bioGreen)
            Text(label).font(.system(size: 12)).foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }

    private var statDivider: some View {
        Rectangle().fill(Color.white.opacity(0.2)).frame(width: 1, height: 30)
    }
}
