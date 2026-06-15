import SwiftUI

// MARK: - 设计系统：间距 / 圆角 / 字阶 / 卡片 / iPad 可读宽度（移植自 Apex 家族）

enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 28
}

enum Radius {
    static let chip: CGFloat = 8
    static let inner: CGFloat = 12
    static let card: CGFloat = 20
    static let hero: CGFloat = 24
}

enum AppFont {
    static let sectionTitle = Font.headline
    static let cardTitle = Font.subheadline.weight(.bold)
    static let body = Font.subheadline
    static let caption = Font.caption
    static let chip = Font.system(size: 11, weight: .semibold)
    static func bigStat(_ size: CGFloat = 30) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }
}

extension View {
    func cardShadow() -> some View {
        shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
    func cardSurface(padding: CGFloat = Spacing.xl) -> some View {
        self
            .padding(padding)
            .background(Color.bioCardSurface)
            .cornerRadius(Radius.card)
            .cardShadow()
    }
    /// iPad（regular 宽度）下限制正文最大宽度并居中，iPhone 无影响。
    func readableWidth(_ maxWidth: CGFloat = 640) -> some View {
        modifier(ReadableWidthModifier(maxWidth: maxWidth))
    }
}

private struct ReadableWidthModifier: ViewModifier {
    let maxWidth: CGFloat
    @Environment(\.horizontalSizeClass) private var sizeClass
    func body(content: Content) -> some View {
        if sizeClass == .regular {
            content.frame(maxWidth: maxWidth).frame(maxWidth: .infinity)
        } else {
            content
        }
    }
}

// MARK: - 通用小组件

struct TagChip: View {
    let text: String
    var color: Color = .bioGreen
    var body: some View {
        Text(text)
            .font(AppFont.chip)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}

struct SectionHeader: View {
    let title: String
    var systemImage: String? = nil
    var accent: Color = .bioGreen
    var body: some View {
        HStack(spacing: 6) {
            if let systemImage { Image(systemName: systemImage).foregroundColor(accent) }
            Text(title).font(AppFont.sectionTitle)
            Spacer()
        }
    }
}

struct ContentUnavailableViewCompat: View {
    let title: String
    let systemImage: String
    let description: String
    var body: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: systemImage).font(.system(size: 48)).foregroundColor(.secondary)
            Text(title).font(.headline)
            Text(description).font(.subheadline).foregroundColor(.secondary)
                .multilineTextAlignment(.center).padding(.horizontal, Spacing.xxl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bioBackground.ignoresSafeArea())
    }
}
