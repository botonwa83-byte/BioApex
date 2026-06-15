import SwiftUI

// MARK: - 细胞图鉴：动/植物细胞，点细胞器看结构与功能（考点热度着色）

struct CellAtlasView: View {
    @State private var mode = 0   // 0 动物 / 1 植物
    @State private var selected: Organelle? = nil

    private var presence: CellPresence { mode == 0 ? .animalOnly : .plantOnly }
    private var organelles: [Organelle] { OrganelleData.organelles(in: presence) }
    private let columns = [GridItem(.flexible(), spacing: Spacing.md), GridItem(.flexible(), spacing: Spacing.md)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Picker("细胞类型", selection: $mode) {
                    Text("动物细胞").tag(0)
                    Text("植物细胞").tag(1)
                }
                .pickerStyle(.segmented)

                Text("点开任意细胞器看结构与功能；越亮=考点热度越高。")
                    .font(.caption).foregroundColor(.secondary)

                LazyVGrid(columns: columns, spacing: Spacing.md) {
                    ForEach(organelles) { o in
                        organelleCell(o)
                    }
                }

                legend
            }
            .padding(Spacing.lg)
            .readableWidth()
        }
        .background(Color.bioBackground.ignoresSafeArea())
        .navigationTitle("细胞图鉴")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selected) { o in OrganelleDetailView(organelle: o).presentationDetents([.medium, .large]) }
    }

    private func organelleCell(_ o: Organelle) -> some View {
        Button { selected = o } label: {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: o.icon).font(.title3).foregroundColor(.bioGreen)
                    Spacer()
                    if o.examHeat >= 3 { Image(systemName: "flame.fill").font(.caption2).foregroundColor(.bioGold) }
                }
                Text(o.name).font(AppFont.cardTitle).foregroundColor(.primary)
                Text(o.membrane).font(.caption2).foregroundColor(.secondary).lineLimit(1)
                if o.presence != .both {
                    TagChip(text: o.presence.label, color: o.presence == .plantOnly ? .bioGreen : .bioBlue)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.md)
            .background(Color.bioGreen.opacity(heatOpacity(o.examHeat)))
            .overlay(RoundedRectangle(cornerRadius: Radius.inner).stroke(Color.bioGreen.opacity(0.25), lineWidth: 1))
            .cornerRadius(Radius.inner)
        }
        .buttonStyle(.plain)
    }

    private func heatOpacity(_ h: Int) -> Double { [0.06, 0.10, 0.16, 0.24][min(h, 3)] }

    private var legend: some View {
        HStack(spacing: Spacing.md) {
            Label("考点高频", systemImage: "flame.fill").font(.caption2).foregroundColor(.bioGold)
            Spacer()
            Text("共 \(organelles.count) 个结构").font(.caption2).foregroundColor(.secondary)
        }
    }
}

struct OrganelleDetailView: View {
    let organelle: Organelle
    private var scene: ProcessScene? { organelle.relatedProcessId.flatMap { ProcessData.scene(id: $0) } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    HStack(spacing: Spacing.md) {
                        Image(systemName: organelle.icon).font(.system(size: 40)).foregroundColor(.bioGreen)
                            .frame(width: 72, height: 72).background(Color.bioGreen.opacity(0.12)).cornerRadius(Radius.inner)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(organelle.name).font(.title2.bold())
                            HStack(spacing: 6) {
                                TagChip(text: organelle.presence.label, color: .bioTeal)
                                TagChip(text: organelle.membrane, color: .bioBlue)
                            }
                        }
                        Spacer()
                    }
                    infoBlock("结构", organelle.structure, "cube", .bioBlue)
                    infoBlock("功能", organelle.function, "bolt.fill", .bioGreen)
                    if organelle.examHeat > 0 {
                        HStack(spacing: 4) {
                            Text("考点热度").font(.caption).foregroundColor(.secondary)
                            ForEach(0..<organelle.examHeat, id: \.self) { _ in
                                Image(systemName: "flame.fill").font(.caption2).foregroundColor(.bioGold)
                            }
                        }
                    }
                    if let s = scene {
                        NavigationLink { ProcessTheaterView(scene: s) } label: {
                            HStack {
                                Image(systemName: "play.circle.fill").foregroundColor(.bioTeal)
                                Text("看相关过程 · \(s.title)").font(AppFont.cardTitle)
                                Spacer(); Image(systemName: "chevron.right").font(.caption)
                            }
                            .foregroundColor(.primary).padding(Spacing.lg)
                            .frame(maxWidth: .infinity).background(Color.bioTeal.opacity(0.1)).cornerRadius(Radius.card)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(Spacing.lg)
            }
            .background(Color.bioBackground.ignoresSafeArea())
            .navigationTitle("细胞器").navigationBarTitleDisplayMode(.inline)
        }
    }

    private func infoBlock(_ label: String, _ text: String, _ icon: String, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(label, systemImage: icon).font(AppFont.chip).foregroundColor(color)
            Text(text).font(.subheadline).foregroundColor(.primary.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg).background(color.opacity(0.08)).cornerRadius(Radius.card)
    }
}
