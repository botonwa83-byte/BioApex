import SwiftUI

// MARK: - 配色（生命绿系，bio* 语义；自适应深浅色）

extension Color {
    // 底色
    static let bioBackground = Color(UIColor { tc in
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0x14191A) : UIColor(hex6: 0xF1F6F1)
    })
    static let bioCardSurface = Color(UIColor { tc in
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0x1F2A24) : UIColor(hex6: 0xFFFFFF)
    })

    // 强调色
    static let bioGreen = Color(UIColor { tc in   // 主色：生命绿
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0x66BB6A) : UIColor(hex6: 0x43A047)
    })
    static let bioTeal = Color(UIColor { tc in    // 次色：青绿（过程/能量）
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0x4DB6AC) : UIColor(hex6: 0x00897B)
    })
    static let bioBlue = Color(UIColor { tc in    // 实验/探究
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0x64B5F6) : UIColor(hex6: 0x1E88E5)
    })
    static let bioPurple = Color(UIColor { tc in  // 遗传/神探
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0xBA8FE0) : UIColor(hex6: 0x8E44AD)
    })
    static let bioGold = Color(UIColor { tc in    // 高亮/掌握
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0xFFB74D) : UIColor(hex6: 0xF59E0B)
    })
    static let bioDanger = Color(UIColor { _ in UIColor(hex6: 0xEF5350) })

    // 段位色
    static let stageJunior = Color(UIColor { tc in   // 初中
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0x81C784) : UIColor(hex6: 0x66BB6A)
    })
    static let stageSenior = Color(UIColor { tc in   // 必修
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0x4DB6AC) : UIColor(hex6: 0x00897B)
    })
    static let stageElective = Color(UIColor { tc in // 选择性必修
        tc.userInterfaceStyle == .dark ? UIColor(hex6: 0x64B5F6) : UIColor(hex6: 0x1E88E5)
    })
}

extension UIColor {
    convenience init(hex6: UInt32) {
        self.init(
            red:   CGFloat((hex6 >> 16) & 0xFF) / 255,
            green: CGFloat((hex6 >> 8)  & 0xFF) / 255,
            blue:  CGFloat( hex6        & 0xFF) / 255,
            alpha: 1
        )
    }
}

// MARK: - 外观偏好

enum AppearancePreference: String, CaseIterable, Identifiable {
    case system, light, dark
    var id: String { rawValue }
    var label: String {
        switch self {
        case .system: return "跟随系统"
        case .light:  return "浅色"
        case .dark:   return "深色"
        }
    }
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}

final class AppearanceManager: ObservableObject {
    static let shared = AppearanceManager()
    private let storageKey = "appearance_preference"
    @Published var preference: AppearancePreference {
        didSet { UserDefaults.standard.set(preference.rawValue, forKey: storageKey) }
    }
    var colorScheme: ColorScheme? { preference.colorScheme }
    private init() {
        let raw = UserDefaults.standard.string(forKey: storageKey) ?? ""
        preference = AppearancePreference(rawValue: raw) ?? .system
    }
}
