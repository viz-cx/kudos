#!/usr/bin/env swift
//
// GenerateAppIcon.swift
// Reproducible generator for the Kudos app icon (1024×1024, opaque, no alpha).
//
// Usage:
//   swift tools/GenerateAppIcon.swift <variant> <output.png>
//
// Variants:
//   gradient-peach  – coral→magenta gradient heart on a warm peach canvas (matches app canvas)
//   white-on-warm   – white heart on the warm gradient (polished version of the current icon)
//   sparkle         – white heart on gradient with a small joyful sparkle
//   badge-heart     – gradient heart with an inset "chat" notch (a heart-shaped message of thanks)
//
// Renders in an sRGB context with noneSkipLast so the written PNG carries no alpha channel.

import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

let S: CGFloat = 1024

// MARK: - Palette (drawn from the coral→pink→magenta brand gradient)

func rgb(_ r: Int, _ g: Int, _ b: Int) -> CGColor {
    CGColor(srgbRed: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
}

let peach   = rgb(255, 243, 236)   // #FFF3EC — the app's canvas
let coral    = rgb(255, 148, 108)   // warm coral (top-left)
let pink      = rgb(255, 122, 168)   // pink (middle)
let magenta = rgb(226, 78, 154)    // magenta (bottom-right)

// MARK: - Heart geometry (smooth parametric heart, sampled as a polygon)

func heartPath(in rect: CGRect) -> CGPath {
    let path = CGMutablePath()
    let cx = rect.midX
    let cy = rect.midY
    let scale = rect.width / 34.0   // parametric heart spans ~[-16,16] x, ~[-17,12] y
    var first = true
    var t: CGFloat = 0
    while t <= 2 * .pi + 0.01 {
        let x = 16 * pow(sin(t), 3)
        let y = 13 * cos(t) - 5 * cos(2*t) - 2 * cos(3*t) - cos(4*t)
        // parametric y is "up"; flip for screen coords (origin bottom-left in CG bitmap)
        let px = cx + x * scale
        let py = cy + y * scale
        if first { path.move(to: CGPoint(x: px, y: py)); first = false }
        else { path.addLine(to: CGPoint(x: px, y: py)) }
        t += 0.01
    }
    path.closeSubpath()
    return path
}

// MARK: - Drawing helpers

func drawLinearGradient(_ ctx: CGContext, colors: [CGColor], start: CGPoint, end: CGPoint) {
    let space = CGColorSpaceCreateDeviceRGB()
    let locs: [CGFloat] = colors.count == 3 ? [0, 0.5, 1] : [0, 1]
    guard let grad = CGGradient(colorsSpace: space, colors: colors as CFArray, locations: locs) else { return }
    ctx.drawLinearGradient(grad, start: start, end: end, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
}

func fillBackground(_ ctx: CGContext, variant: String) {
    if variant == "gradient-peach" {
        // soft peach canvas with a barely-there warm glow, top-left
        ctx.setFillColor(peach)
        ctx.fill(CGRect(x: 0, y: 0, width: S, height: S))
        let space = CGColorSpaceCreateDeviceRGB()
        let glow = [rgb(255, 224, 206), peach]
        if let g = CGGradient(colorsSpace: space, colors: glow as CFArray, locations: [0, 1]) {
            ctx.drawRadialGradient(g,
                startCenter: CGPoint(x: S*0.32, y: S*0.72), startRadius: 0,
                endCenter: CGPoint(x: S*0.32, y: S*0.72), endRadius: S*0.75,
                options: [])
        }
    } else {
        // warm brand gradient, top-left coral → bottom-right magenta
        drawLinearGradient(ctx, colors: [coral, pink, magenta],
                           start: CGPoint(x: 0, y: S), end: CGPoint(x: S, y: 0))
        // upper-left radial highlight for depth
        let space = CGColorSpaceCreateDeviceRGB()
        let hi = [rgb(255, 190, 150), magenta]
        if let g = CGGradient(colorsSpace: space, colors: hi as CFArray, locations: [0, 1]) {
            ctx.saveGState()
            ctx.setBlendMode(.softLight)
            ctx.setAlpha(0.55)
            ctx.drawRadialGradient(g,
                startCenter: CGPoint(x: S*0.28, y: S*0.78), startRadius: 0,
                endCenter: CGPoint(x: S*0.28, y: S*0.78), endRadius: S*0.9, options: [])
            ctx.restoreGState()
        }
    }
}

func drawHeart(_ ctx: CGContext, variant: String) {
    let side = S * 0.46
    let rect = CGRect(x: (S-side)/2, y: (S-side)/2, width: side, height: side)
    let path = heartPath(in: rect)

    // soft drop shadow under the heart
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: -18),
                  blur: 46,
                  color: rgb(120, 30, 70).copy(alpha: 0.28))

    if variant == "gradient-peach" || variant == "badge-heart" {
        // gradient-filled heart on peach
        ctx.addPath(path)
        ctx.clip()
        drawLinearGradient(ctx, colors: [coral, pink, magenta],
                           start: CGPoint(x: rect.minX, y: rect.maxY),
                           end: CGPoint(x: rect.maxX, y: rect.minY))
    } else {
        // white heart with a faint top-down depth gradient
        ctx.addPath(path)
        ctx.clip()
        drawLinearGradient(ctx, colors: [rgb(255,255,255), rgb(255,244,248)],
                           start: CGPoint(x: rect.midX, y: rect.maxY),
                           end: CGPoint(x: rect.midX, y: rect.minY))
    }
    ctx.restoreGState()

    if variant == "sparkle" {
        drawSparkle(ctx, center: CGPoint(x: rect.maxX - side*0.02, y: rect.maxY - side*0.02), size: side*0.16, color: rgb(255,255,255))
        drawSparkle(ctx, center: CGPoint(x: rect.maxX + side*0.14, y: rect.maxY - side*0.22), size: side*0.08, color: rgb(255,255,255))
    }
    if variant == "badge-heart" {
        // small white "chat notch" cut visually by overlaying a peach rounded triangle tail at lower-left
        let tail = CGMutablePath()
        let bx = rect.minX + side*0.18
        let by = rect.minY + side*0.02
        tail.move(to: CGPoint(x: bx, y: by))
        tail.addLine(to: CGPoint(x: bx - side*0.16, y: by - side*0.14))
        tail.addLine(to: CGPoint(x: bx + side*0.10, y: by + side*0.06))
        tail.closeSubpath()
        ctx.addPath(tail)
        ctx.setFillColor(peach)
        ctx.fillPath()
    }
}

func drawSparkle(_ ctx: CGContext, center: CGPoint, size: CGFloat, color: CGColor) {
    // four-point star (diamond with concave sides)
    let p = CGMutablePath()
    let k = size * 0.28   // waist
    p.move(to: CGPoint(x: center.x, y: center.y + size))
    p.addQuadCurve(to: CGPoint(x: center.x + size, y: center.y), control: CGPoint(x: center.x + k, y: center.y + k))
    p.addQuadCurve(to: CGPoint(x: center.x, y: center.y - size), control: CGPoint(x: center.x + k, y: center.y - k))
    p.addQuadCurve(to: CGPoint(x: center.x - size, y: center.y), control: CGPoint(x: center.x - k, y: center.y - k))
    p.addQuadCurve(to: CGPoint(x: center.x, y: center.y + size), control: CGPoint(x: center.x - k, y: center.y + k))
    p.closeSubpath()
    ctx.saveGState()
    ctx.setShadow(offset: .zero, blur: 24, color: color.copy(alpha: 0.9))
    ctx.addPath(p)
    ctx.setFillColor(color)
    ctx.fillPath()
    ctx.restoreGState()
}

// MARK: - Main

let args = CommandLine.arguments
guard args.count >= 3 else {
    FileHandle.standardError.write("usage: swift GenerateAppIcon.swift <variant> <output.png>\n".data(using: .utf8)!)
    exit(1)
}
let variant = args[1]
let outPath = args[2]

let space = CGColorSpace(name: CGColorSpace.sRGB)!
guard let ctx = CGContext(data: nil, width: Int(S), height: Int(S), bitsPerComponent: 8,
                          bytesPerRow: 0, space: space,
                          bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else {
    FileHandle.standardError.write("failed to create context\n".data(using: .utf8)!)
    exit(1)
}

fillBackground(ctx, variant: variant)
drawHeart(ctx, variant: variant)

guard let image = ctx.makeImage() else { exit(1) }
let url = URL(fileURLWithPath: outPath)
guard let dest = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else { exit(1) }
CGImageDestinationAddImage(dest, image, nil)
CGImageDestinationFinalize(dest)
print("wrote \(outPath) [\(variant)]")
