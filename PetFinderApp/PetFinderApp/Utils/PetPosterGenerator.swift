//
//  PetPosterGenerator.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 18.04.2026.
//

import UIKit
import CoreImage

// MARK: - Format

enum PosterFormat: String, CaseIterable {
    case square = "Квадрат"
    case story  = "9:16"
    case a4     = "A4"
    case a3     = "A3"

    var size: CGSize {
        switch self {
        case .square: return CGSize(width: 1080, height: 1080)
        case .story:  return CGSize(width: 1080, height: 1920)
        case .a4:     return CGSize(width: 794,  height: 1123)
        case .a3:     return CGSize(width: 1123, height: 1587)
        }
    }
}

// MARK: - Public API

struct PetPosterGenerator {
    static func generate(pet: Pet, photo: UIImage?, city: String? = nil, format: PosterFormat) -> UIImage {
        PosterCanvas(pet: pet, photo: photo, city: city, format: format).render()
    }
}

// MARK: - Canvas

private final class PosterCanvas {

    let accent = UIColor(red: 0.09, green: 0.71, blue: 1.00, alpha: 1)
    let dark   = UIColor(red: 0.08, green: 0.08, blue: 0.10, alpha: 1)

    let pet:    Pet
    let photo:  UIImage?
    let city:   String?
    let format: PosterFormat

    let W: CGFloat
    let H: CGFloat

    let B:   CGFloat
    let pad: CGFloat

    let cx: CGFloat
    let cy: CGFloat

    let colSplit: CGFloat
    let rowSplit: CGFloat

    let photoW: CGFloat
    let photoH: CGFloat

    let footerY:    CGFloat
    let mainBottom: CGFloat

    init(pet: Pet, photo: UIImage?, city: String?, format: PosterFormat) {
        self.pet    = pet
        self.photo  = photo
        self.city   = city
        self.format = format

        let size = format.size
        W = size.width
        H = size.height

        B   = max(40, W * 0.055)
        pad = max(14, W * 0.018)

        cx = B + pad
        cy = B + pad

        let cw = W - 2 * (B + pad)

        let footerFS: CGFloat = max(11, W * 0.016)
        let footerFontH = UIFont.systemFont(ofSize: footerFS, weight: .regular).lineHeight
        let footerGap: CGFloat = max(8, H * 0.008)
        footerY     = H - B - pad - footerFontH
        mainBottom  = footerY - footerGap

        let mainH = mainBottom - cy

        let colRatio: CGFloat
        let rowRatio: CGFloat
        switch format {
        case .square: (colRatio, rowRatio) = (0.520, 0.530)
        case .story:  (colRatio, rowRatio) = (0.500, 0.400)
        case .a4, .a3:(colRatio, rowRatio) = (0.510, 0.450)
        }

        colSplit  = cx + cw * colRatio
        rowSplit  = cy + mainH * rowRatio

        photoW = colSplit - cx
        photoH = rowSplit - cy
    }

    // MARK: - Render

    func render() -> UIImage {
        UIGraphicsImageRenderer(size: CGSize(width: W, height: H)).image { ctx in
            draw(in: ctx.cgContext)
        }
    }

    private func draw(in cg: CGContext) {

        accent.setFill()
        cg.fill(CGRect(x: 0, y: 0, width: W, height: H))

        UIColor.white.setFill()
        cg.fill(CGRect(x: B, y: B, width: W - 2*B, height: H - 2*B))

        blitPhoto(photo, in: CGRect(x: cx, y: cy, width: photoW, height: photoH),
                  ctx: cg, radius: 6)

        let infoX = colSplit + pad
        let infoW = W - B - pad - colSplit - pad
        var iy = cy

        let logoH: CGFloat = max(40, W * 0.050)
        let logoW: CGFloat = logoH * (435.0 / 239.0)
        drawLogoRaw(in: CGRect(x: W - B - pad - logoW, y: iy,
                               width: logoW, height: logoH))
        iy += logoH + max(10, H * 0.010)

        let nameFont = fitFont(text: pet.name, maxW: infoW,
                               max: max(28, W * 0.052), weight: .bold)
        put(pet.name, at: CGPoint(x: infoX, y: iy), font: nameFont, color: dark)
        iy += nameFont.lineHeight + 4

        let baStr = breedAge()
        if !baStr.isEmpty {
            let baFont = fitFont(text: baStr, maxW: infoW,
                                 max: max(17, W * 0.028), weight: .regular)
            put(baStr, at: CGPoint(x: infoX, y: iy),
                font: baFont, color: UIColor(white: 0.40, alpha: 1))
            iy += baFont.lineHeight + max(8, H * 0.008)
        }
        
        drawInfoRows(origin: CGPoint(x: infoX, y: iy),
                     maxW: infoW, maxH: rowSplit - iy - pad,
                     maxFS: max(17, W * 0.028))

        let leftW = photoW - pad

        let phone    = pet.contactPhone?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let hasPhone = !phone.isEmpty

        let callFS   = max(16, W * 0.030)
        let callFont = UIFont.systemFont(ofSize: callFS, weight: .semibold)
        let phoneMaxFS: CGFloat = max(20, W * 0.046)

        let reservedH: CGFloat = hasPhone
            ? callFont.lineHeight + 4 + phoneMaxFS * 1.25 + 10
            : 0

        let botH    = mainBottom - rowSplit - pad
        let bigAvail = botH - reservedH
        let bigFS   = min(W * 0.108, bigAvail / 3 * 0.88)
        let bigFont = fitFont(text: "ПОМОГИТЕ", maxW: leftW, max: bigFS, weight: .black)

        var by = rowSplit + pad
        for word in ["ПОМОГИТЕ", "НАЙТИ", "ПИТОМЦА"] {
            put(word, at: CGPoint(x: cx, y: by), font: bigFont, color: dark)
            by += bigFont.lineHeight
        }

        if hasPhone {
            by += 8
            put("Звоните:", at: CGPoint(x: cx, y: by), font: callFont, color: accent)
            by += callFont.lineHeight + 4
            let pFont = fitFont(text: phone, maxW: leftW, max: phoneMaxFS, weight: .bold)
            put(phone, at: CGPoint(x: cx, y: by), font: pFont, color: accent)
        }

        let rightX = colSplit + pad
        let rightW = infoW   // same as info column width

        let captFS    = max(11, W * 0.017)
        let captFont  = UIFont.systemFont(ofSize: captFS, weight: .regular)
        let captStr   = "объявление\nв приложении Лапки"
        let captStyle = NSMutableParagraphStyle()
        captStyle.alignment = .center
        let captAttrs: [NSAttributedString.Key: Any] = [
            .font: captFont,
            .foregroundColor: UIColor(white: 0.50, alpha: 1),
            .paragraphStyle: captStyle
        ]
        let captGap: CGFloat = max(6, H * 0.005)

        let totalAvail = mainBottom - (rowSplit + pad)

        var qrSide = min(min(photoW, photoH) * 0.65, min(rightW * 0.85, totalAvail))
        while qrSide >= 30 {
            let captH = ceil((captStr as NSString)
                .boundingRect(with: CGSize(width: qrSide, height: 400),
                              options: .usesLineFragmentOrigin,
                              attributes: captAttrs, context: nil).height)
            if captH + captGap + qrSide <= totalAvail { break }
            qrSide -= 4
        }
        qrSide = max(0, qrSide)

        let qrX = rightX + (rightW - qrSide) / 2

        let captH = ceil((captStr as NSString)
            .boundingRect(with: CGSize(width: qrSide, height: 400),
                          options: .usesLineFragmentOrigin,
                          attributes: captAttrs, context: nil).height)

        var ry2 = rowSplit + pad
        if qrSide >= 30 {
            (captStr as NSString).draw(
                in: CGRect(x: qrX, y: ry2, width: qrSide, height: captH + 4),
                withAttributes: captAttrs)
            ry2 += captH + captGap

            if let qrImg = makeQR(for: pet, side: qrSide) {
                cg.saveGState()
                cg.interpolationQuality = .none
                qrImg.draw(in: CGRect(x: qrX, y: ry2, width: qrSide, height: qrSide))
                cg.restoreGState()
            }
        }

        let footerStr  = "лапки  |  портал для поиска потерявшихся домашних животных"
        let footerFont = UIFont.systemFont(ofSize: max(11, W * 0.016), weight: .regular)
        let footerStyle = NSMutableParagraphStyle()
        footerStyle.alignment = .center
        let footerAttrs: [NSAttributedString.Key: Any] = [
            .font: footerFont,
            .foregroundColor: UIColor(white: 0.45, alpha: 1),
            .paragraphStyle: footerStyle
        ]
        (footerStr as NSString).draw(
            in: CGRect(x: cx, y: footerY, width: W - 2*(B + pad), height: footerFont.lineHeight + 4),
            withAttributes: footerAttrs)
    }

    // MARK: - Logo (raw PNG, no decoration)

    private func drawLogoRaw(in rect: CGRect) {
        guard let logo = UIImage(named: "logo_lapki") else {
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: rect.height * 0.52, weight: .bold),
                .foregroundColor: dark
            ]
            let t = "🐾 лапки" as NSString
            let sz = t.size(withAttributes: attrs)
            t.draw(at: CGPoint(x: rect.minX + (rect.width - sz.width) / 2,
                               y: rect.minY + (rect.height - sz.height) / 2),
                   withAttributes: attrs)
            return
        }
        let scale = min(rect.width / logo.size.width, rect.height / logo.size.height)
        let dw = logo.size.width  * scale
        let dh = logo.size.height * scale
        let dx = rect.minX + (rect.width  - dw) / 2
        let dy = rect.minY + (rect.height - dh) / 2
        logo.draw(in: CGRect(x: dx, y: dy, width: dw, height: dh))
    }

    // MARK: - Info rows

    private func drawInfoRows(origin: CGPoint, maxW: CGFloat, maxH: CGFloat, maxFS: CGFloat) {
        var rows: [(String, String)] = []

        if let d = pet.lostDate {
            let df = DateFormatter()
            df.locale = Locale(identifier: "ru_RU")
            df.dateFormat = "d MMMM yyyy"
            rows.append(("дата пропажи:", df.string(from: d)))
        }

        var loc = pet.location
        if let c = city, !c.isEmpty, !loc.localizedCaseInsensitiveContains(c) {
            loc = c + (loc.isEmpty ? "" : ", " + loc)
        }
        if !loc.isEmpty { rows.append(("место:", loc)) }

        if let s = pet.externalSigns, !s.isEmpty { rows.append(("приметы:", s)) }
        if !pet.description.isEmpty              { rows.append(("описание:", pet.description)) }
        guard !rows.isEmpty else { return }

        var fs = maxFS
        while fs >= 11, totalInfoH(rows: rows, fs: fs, maxW: maxW) > maxH { fs -= 1 }

        let lbl  = UIFont.systemFont(ofSize: fs, weight: .bold)
        let val  = UIFont.systemFont(ofSize: fs, weight: .regular)
        let gap: CGFloat = max(5, fs * 0.30)
        var y = origin.y
        for (label, value) in rows {
            let as_ = infoAttr(label: label, value: value, lbl: lbl, val: val)
            let h = as_.boundingRect(with: CGSize(width: maxW, height: .greatestFiniteMagnitude),
                                     options: .usesLineFragmentOrigin, context: nil).height
            as_.draw(in: CGRect(x: origin.x, y: y, width: maxW, height: h + 2))
            y += h + gap
        }
    }

    private func totalInfoH(rows: [(String, String)], fs: CGFloat, maxW: CGFloat) -> CGFloat {
        let lbl = UIFont.systemFont(ofSize: fs, weight: .bold)
        let val = UIFont.systemFont(ofSize: fs, weight: .regular)
        let gap: CGFloat = max(5, fs * 0.30)
        return rows.reduce(0) { acc, row in
            acc + infoAttr(label: row.0, value: row.1, lbl: lbl, val: val)
                .boundingRect(with: CGSize(width: maxW, height: .greatestFiniteMagnitude),
                              options: .usesLineFragmentOrigin, context: nil).height + gap
        }
    }

    private func infoAttr(label: String, value: String,
                           lbl: UIFont, val: UIFont) -> NSAttributedString {
        let s = NSMutableAttributedString()
        s.append(NSAttributedString(string: label + " ",
                                    attributes: [.font: lbl, .foregroundColor: dark]))
        s.append(NSAttributedString(string: value,
                                    attributes: [.font: val, .foregroundColor: dark]))
        return s
    }

    // MARK: - Helpers

    private func blitPhoto(_ image: UIImage?, in rect: CGRect, ctx: CGContext, radius: CGFloat) {
        ctx.saveGState()
        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        if let image {
            image.draw(in: rect.aspectFill(imageSize: image.size))
        } else {
            UIColor(white: 0.87, alpha: 1).setFill(); UIRectFill(rect)
        }
        ctx.restoreGState()
    }

    private func put(_ text: String, at p: CGPoint, font: UIFont, color: UIColor) {
        (text as NSString).draw(at: p, withAttributes: [.font: font, .foregroundColor: color])
    }

    private func fitFont(text: String, maxW: CGFloat, max m: CGFloat,
                          weight: UIFont.Weight, min lo: CGFloat = 10) -> UIFont {
        var pt = m
        while pt > lo {
            let f = UIFont.systemFont(ofSize: pt, weight: weight)
            if (text as NSString).size(withAttributes: [.font: f]).width <= maxW { return f }
            pt -= 1
        }
        return UIFont.systemFont(ofSize: lo, weight: weight)
    }

    private func breedAge() -> String {
        var parts: [String] = []
        if !pet.breed.isEmpty       { parts.append(pet.breed) }
        if let a = pet.age, a > 0   { parts.append(ageStr(a)) }
        return parts.joined(separator: " | ")
    }

    private func ageStr(_ age: Int) -> String {
        let m100 = age % 100, m10 = age % 10
        if m100 >= 11 && m100 <= 14 { return "\(age) лет" }
        switch m10 {
        case 1:       return "\(age) год"
        case 2, 3, 4: return "\(age) года"
        default:      return "\(age) лет"
        }
    }

    // MARK: - QR

    private func makeQR(for pet: Pet, side: CGFloat) -> UIImage? {
        let url = "http://178.154.198.101:8080/view/pets/\(pet.id)"
        guard let data   = url.data(using: .utf8),
              let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M",  forKey: "inputCorrectionLevel")
        guard let ciOut = filter.outputImage else { return nil }

        let scale  = side / ciOut.extent.width
        let scaled = ciOut.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        guard let cgImg = CIContext(options: [.useSoftwareRenderer: false])
            .createCGImage(scaled, from: scaled.extent) else { return nil }

        let sz = CGSize(width: side, height: side)
        return UIGraphicsImageRenderer(size: sz).image { _ in
            UIColor.white.setFill()
            UIRectFill(CGRect(origin: .zero, size: sz))
            UIImage(cgImage: cgImg).draw(in: CGRect(origin: .zero, size: sz))
        }
    }
}

// MARK: - CGRect aspect-fill

private extension CGRect {
    func aspectFill(imageSize s: CGSize) -> CGRect {
        let scale = max(width / s.width, height / s.height)
        let w = s.width * scale, h = s.height * scale
        return CGRect(x: minX + (width - w) / 2, y: minY + (height - h) / 2, width: w, height: h)
    }
}
