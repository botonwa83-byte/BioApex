import SwiftUI

// MARK: - 概念关联网（按 4 大生命观念把考点串成网）

struct ConceptMapView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text("生物高度互联——按生命观念把考点串成网，比孤立背诵高效得多。")
                    .font(.caption).foregroundColor(.secondary)
                ForEach(LifeConcept.allCases) { concept in
                    conceptCard(concept)
                }
            }
            .padding(Spacing.lg).readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("概念关联网").navigationBarTitleDisplayMode(.inline)
    }

    private func conceptCard(_ concept: LifeConcept) -> some View {
        let points = ConceptData.points(for: concept)
        return VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.md) {
                Image(systemName: concept.icon).font(.title3).frame(width: 40, height: 40)
                    .background(concept.color.opacity(0.15)).foregroundColor(concept.color).cornerRadius(Radius.inner)
                VStack(alignment: .leading, spacing: 2) {
                    Text(concept.title).font(AppFont.cardTitle)
                    Text(concept.subtitle).font(.caption2).foregroundColor(.secondary)
                }
            }
            ForEach(points) { p in
                NavigationLink { KnowledgePointDetailView(point: p) } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "circle.fill").font(.system(size: 5)).foregroundColor(concept.color)
                        Text(p.title).font(.subheadline).foregroundColor(.primary)
                        Spacer()
                        Text(p.module.shortTitle).font(.caption2).foregroundColor(.secondary)
                        Image(systemName: "chevron.right").font(.caption2).foregroundColor(.secondary)
                    }
                    .padding(.vertical, 3)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading).cardSurface(padding: Spacing.lg)
    }
}
