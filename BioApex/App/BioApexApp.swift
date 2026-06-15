import SwiftUI

@main
struct BioApexApp: App {
    @StateObject private var appearance = AppearanceManager.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(appearance.colorScheme)
        }
    }
}

/// 每次启动先展示广告页（对标 Apex 家族），点击进入主界面。
/// 启动参数：-skipPromo 或任意 -demo* 跳过广告页。
struct RootView: View {
    @State private var passedPromo: Bool = {
        let args = ProcessInfo.processInfo.arguments
        return args.contains("-skipPromo") || args.contains { $0.hasPrefix("-demo") }
    }()

    var body: some View {
        ZStack {
            if passedPromo {
                MainTabView().transition(.opacity)
            } else {
                PromoView { withAnimation(.easeInOut(duration: 0.4)) { passedPromo = true } }
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: passedPromo)
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            MasteryMapView()
                .tabItem { Label("掌握地图", systemImage: "chart.bar.doc.horizontal") }
                .tag(0)

            SeeLifeView()
                .tabItem { Label("看见生命", systemImage: "play.square.stack") }
                .tag(1)

            ReasoningView()
                .tabItem { Label("推理场", systemImage: "puzzlepiece.extension") }
                .tag(2)

            MoreView()
                .tabItem { Label("更多", systemImage: "ellipsis.circle") }
                .tag(3)
        }
        .tint(.bioGreen)
    }
}

// MARK: - 更多

struct MoreView: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            List {
                if !purchase.isUnlocked {
                    Section {
                        Button { showPaywall = true } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "crown.fill").font(.title3).foregroundColor(.bioGold)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("解锁完整版").font(.headline).foregroundColor(.primary)
                                    Text("必修2 + 选必全部考点 · 全部过程剧场 · 神探/实验台，一次买断")
                                        .font(.caption).foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section("我的学习") {
                    NavigationLink { ConfusionListView() } label: {
                        Label("易混辨析对决", systemImage: "arrow.left.arrow.right.circle")
                    }
                    NavigationLink { ReviewView() } label: {
                        HStack {
                            Label("智能复习", systemImage: "brain.head.profile")
                            Spacer()
                            let due = ReviewScheduler.shared.dueCount
                            if due > 0 {
                                Text("\(due)").font(AppFont.chip).foregroundColor(.white)
                                    .padding(.horizontal, 7).padding(.vertical, 2)
                                    .background(Color.bioGreen).clipShape(Capsule())
                            }
                        }
                    }
                    NavigationLink { MistakeBookView() } label: {
                        Label("错题本", systemImage: "exclamationmark.triangle")
                    }
                    NavigationLink { DiagnosisView() } label: {
                        Label("学情诊断", systemImage: "chart.bar.xaxis")
                    }
                }

                Section("生命发现") {
                    NavigationLink { GiantsView() } label: {
                        Label("生物巨人", systemImage: "person.3.fill")
                    }
                    NavigationLink { StoryVaultView() } label: {
                        Label("生命档案馆", systemImage: "books.vertical")
                    }
                }
            }
            .navigationTitle("更多")
            .sheet(isPresented: $showPaywall) { PaywallView() }
        }
    }
}

/// 占位：后续阶段填充（智能复习/错题/诊断/巨人/档案馆）。
struct ReviewPlaceholderView: View {
    var body: some View {
        ContentUnavailableViewCompat(
            title: "即将上线",
            systemImage: "hammer",
            description: "该模块在后续开发阶段填充，敬请期待。"
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
