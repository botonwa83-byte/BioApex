import SwiftUI

// MARK: - 生物巨人

struct GiantsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                ForEach(GiantsData.all) { g in
                    NavigationLink { GiantDetailView(giant: g) } label: { row(g) }
                        .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("生物巨人").navigationBarTitleDisplayMode(.inline)
    }

    private func row(_ g: BioGiant) -> some View {
        HStack(spacing: Spacing.lg) {
            Image(systemName: "person.crop.circle.fill").font(.system(size: 40)).foregroundColor(.bioGreen)
            VStack(alignment: .leading, spacing: 4) {
                HStack { Text(g.name).font(AppFont.cardTitle); Text(g.era).font(.caption2).foregroundColor(.secondary) }
                Text(g.title).font(.caption).foregroundColor(.bioGreen)
                Text(g.achievement).font(.caption).foregroundColor(.secondary).lineLimit(2)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .foregroundColor(.primary).cardSurface(padding: Spacing.lg)
    }
}

struct GiantDetailView: View {
    let giant: BioGiant
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(giant.name).font(.largeTitle.bold())
                    Text("\(giant.title) · \(giant.era)").font(.subheadline).foregroundColor(.bioGreen)
                    Text("“\(giant.quote)”").font(.body.italic())
                        .padding(Spacing.lg).frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.bioGreen.opacity(0.08)).cornerRadius(Radius.inner)
                }
                SectionHeader(title: "成就", systemImage: "trophy", accent: .bioGold)
                Text(giant.achievement).font(.subheadline)
                SectionHeader(title: "小传", systemImage: "book", accent: .bioTeal)
                Text(giant.story).font(.subheadline).lineSpacing(4)
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle(giant.name).navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 生命档案馆

struct StoryVaultView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                Text("生命科学史上最动人的瞬间——每篇结尾都钩回一个考点。")
                    .font(.caption).foregroundColor(.secondary).frame(maxWidth: .infinity, alignment: .leading)
                ForEach(LoreData.stories) { s in
                    NavigationLink { StoryDetailView(story: s) } label: { row(s) }
                        .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("生命档案馆").navigationBarTitleDisplayMode(.inline)
    }

    private func row(_ s: LoreStory) -> some View {
        HStack(spacing: Spacing.lg) {
            Image(systemName: s.icon).font(.title2).frame(width: 44, height: 44)
                .background(Color.bioTeal.opacity(0.15)).foregroundColor(.bioTeal).cornerRadius(Radius.inner)
            VStack(alignment: .leading, spacing: 4) {
                Text(s.title).font(AppFont.cardTitle)
                Text(s.subtitle).font(.caption).foregroundColor(.secondary).lineLimit(2)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .foregroundColor(.primary).cardSurface(padding: Spacing.lg)
    }
}

struct StoryDetailView: View {
    let story: LoreStory
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text(story.subtitle).font(.subheadline).foregroundColor(.secondary)
                Text(story.body).font(.body).lineSpacing(5)
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Label("钩回考点", systemImage: "target").font(AppFont.cardTitle).foregroundColor(.bioGreen)
                    Text(story.examHook).font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Spacing.lg).background(Color.bioGreen.opacity(0.1)).cornerRadius(Radius.card)
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle(story.title).navigationBarTitleDisplayMode(.inline)
    }
}
