// BioApex 应用图标:翠绿→青绿渐变 + 白色 DNA 双螺旋主角 + 底部 BioApex 字标。
// 与 ChemApex 图标同一套路(亮色满版渐变 + 白色学科主角 + 字标),只换主色与主角。
// 运行:swift scripts/make_icon.swift  生成后需压平 alpha(App Store 图标不允许透明通道)。
// 坐标原点左下角,y 向上。

import AppKit
import CoreGraphics

let S = 1024
let cs = CGColorSpace(name: CGColorSpace.sRGB)!
let ctx = CGContext(data: nil, width: S, height: S, bitsPerComponent: 8,
                    bytesPerRow: 0, space: cs,
                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    CGColor(colorSpace: cs, components: [r, g, b, a])!
}

// 1. 暖亮的生命绿渐变背景
let bg = CGGradient(colorsSpace: cs,
                    colors: [color(0.42, 0.82, 0.52),   // 顶:嫩绿
                             color(0.22, 0.70, 0.55),   // 中:草绿
                             color(0.06, 0.52, 0.50)] as CFArray, // 底:青绿
                    locations: [0, 0.55, 1])!
ctx.drawLinearGradient(bg, start: CGPoint(x: 180, y: 1024), end: CGPoint(x: 860, y: 0),
                       options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])

// 顶部柔光
let sheen = CGGradient(colorsSpace: cs, colors: [color(1, 1, 1, 0.26), color(1, 1, 1, 0)] as CFArray, locations: [0, 1])!
ctx.drawRadialGradient(sheen, startCenter: CGPoint(x: 360, y: 840), startRadius: 0,
                       endCenter: CGPoint(x: 360, y: 840), endRadius: 620, options: [])

// 2. DNA 双螺旋(白色)
let cx: CGFloat = 512
let bottom: CGFloat = 392, top: CGFloat = 920
let height = top - bottom
let amp: CGFloat = 132
let turns: CGFloat = 1.85
let n = 220

func strandPoint(_ t: CGFloat, phase0: CGFloat) -> CGPoint {
    let y = bottom + t * height
    let phase = t * turns * 2 * .pi + phase0
    return CGPoint(x: cx + amp * sin(phase), y: y)
}

func strandPath(phase0: CGFloat) -> CGPath {
    let p = CGMutablePath()
    for i in 0...n {
        let pt = strandPoint(CGFloat(i) / CGFloat(n), phase0: phase0)
        if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
    }
    return p
}

// 横档(碱基对):连接两条链,在分离较大处绘制
ctx.setShadow(offset: CGSize(width: 0, height: -10), blur: 22, color: color(0.0, 0.25, 0.18, 0.35))
let rungCount = 9
for k in 1..<rungCount {
    let t = CGFloat(k) / CGFloat(rungCount)
    let a = strandPoint(t, phase0: 0)
    let b = strandPoint(t, phase0: .pi)
    if abs(a.x - b.x) < 36 { continue } // 交叉处不画
    ctx.setStrokeColor(color(1, 1, 1, 0.92))
    ctx.setLineWidth(13)
    ctx.setLineCap(.round)
    ctx.move(to: a); ctx.addLine(to: b); ctx.strokePath()
}

// 两条主链
ctx.setStrokeColor(color(1.0, 1.0, 0.99))
ctx.setLineWidth(30)
ctx.setLineCap(.round); ctx.setLineJoin(.round)
ctx.addPath(strandPath(phase0: 0)); ctx.strokePath()
ctx.addPath(strandPath(phase0: .pi)); ctx.strokePath()
ctx.setShadow(offset: .zero, blur: 0, color: nil)

// 3. App 名(双螺旋下方,沿用 Apex 家族字标)
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(cgContext: ctx, flipped: false)
let shadow = NSShadow()
shadow.shadowColor = NSColor(srgbRed: 0.0, green: 0.22, blue: 0.15, alpha: 0.32)
shadow.shadowOffset = NSSize(width: 0, height: -3)
shadow.shadowBlurRadius = 10
let nameAttrs: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 96, weight: .bold),
    .foregroundColor: NSColor(srgbRed: 1, green: 1, blue: 1, alpha: 0.97),
    .kern: 2.0,
    .shadow: shadow,
]
let name = NSAttributedString(string: "BioApex", attributes: nameAttrs)
let nsz = name.size()
name.draw(at: NSPoint(x: (1024 - nsz.width) / 2, y: 150))
NSGraphicsContext.restoreGraphicsState()

// 输出
let img = ctx.makeImage()!
let rep = NSBitmapImageRep(cgImage: img)
let png = rep.representation(using: .png, properties: [:])!
let out = URL(fileURLWithPath: "BioApex/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png")
try! png.write(to: out)
print("✅ icon written to \(out.path)")
