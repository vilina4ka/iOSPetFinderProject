//
//  PetPosterGenerator.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 18.04.2026.
//

import UIKit

enum PosterFormat: String, CaseIterable {
    case a4        = "A4"
    case a3        = "A3"
    case square    = "Квадрат"
    case story     = "9:16"

    var size: CGSize {
        switch self {
        case .a4:     return CGSize(width: 794,  height: 1123)
        case .a3:     return CGSize(width: 1123, height: 1587)
        case .square: return CGSize(width: 1080, height: 1080)
        case .story:  return CGSize(width: 1080, height: 1920)
        }
    }
}

struct PetPosterGenerator {

    static func generate(pet: Pet, photo: UIImage?, format: PosterFormat) -> UIImage {
        let size = format.size
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { ctx in
            let cgCtx = ctx.cgContext
            let rect  = CGRect(origin: .zero, size: size)
            let W = size.width
            let H = size.height

            UIColor(red: 0.98, green: 0.96, blue: 0.94, alpha: 1).setFill()
            cgCtx.fill(rect)

            let headerH = H * 0.13
            let headerRect = CGRect(x: 0, y: 0, width: W, height: headerH)
            UIColor(red: 0.93, green: 0.26, blue: 0.26, alpha: 1).setFill()
            cgCtx.fill(headerRect)

            let titleFont = UIFont.systemFont(ofSize: W * 0.095, weight: .black)
            let titleAttrs: [NSAttributedString.Key: Any] = [
                .font: titleFont,
                .foregroundColor: UIColor.white,
                .kern: W * 0.015
            ]
            let titleStr = "ПРОПАЛ" + ((pet.type.lowercased() == "кошка") ? " КОТ" :
                                        (pet.type.lowercased() == "собака") ? "А СОБАКА" : "")
            let titleSize = (titleStr as NSString).size(withAttributes: titleAttrs)
            (titleStr as NSString).draw(
                at: CGPoint(x: (W - titleSize.width) / 2, y: (headerH - titleSize.height) / 2),
                withAttributes: titleAttrs
            )

            let photoTopPad = headerH + H * 0.03
            let photoH      = H * 0.42
            let photoRect   = CGRect(x: W * 0.06, y: photoTopPad, width: W * 0.88, height: photoH)

            if let photo = photo {
                let path = UIBezierPath(roundedRect: photoRect, cornerRadius: W * 0.04)
                cgCtx.saveGState()
                path.addClip()
                photo.draw(in: photoRect.aspectFillRect(for: photo.size))
                cgCtx.restoreGState()
            } else {
                UIColor(white: 0.88, alpha: 1).setFill()
                UIBezierPath(roundedRect: photoRect, cornerRadius: W * 0.04).fill()
                let paw = "🐾"
                let pawFont = UIFont.systemFont(ofSize: W * 0.18)
                let pawSize = (paw as NSString).size(withAttributes: [.font: pawFont])
                (paw as NSString).draw(
                    at: CGPoint(x: (W - pawSize.width) / 2, y: photoTopPad + (photoH - pawSize.height) / 2),
                    withAttributes: [.font: pawFont]
                )
            }

            var curY = photoTopPad + photoH + H * 0.025

            let nameFont  = UIFont.systemFont(ofSize: W * 0.09, weight: .bold)
            let nameAttrs: [NSAttributedString.Key: Any] = [
                .font: nameFont,
                .foregroundColor: UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
            ]
            let nameStr = pet.name
            let nameSize = (nameStr as NSString).size(withAttributes: nameAttrs)
            (nameStr as NSString).draw(
                at: CGPoint(x: (W - nameSize.width) / 2, y: curY),
                withAttributes: nameAttrs
            )
            curY += nameSize.height + H * 0.01

            let breedStr = [pet.type, pet.breed].filter { !$0.isEmpty }.joined(separator: " · ")
            if !breedStr.isEmpty {
                let breedFont  = UIFont.systemFont(ofSize: W * 0.048, weight: .regular)
                let breedAttrs: [NSAttributedString.Key: Any] = [
                    .font: breedFont,
                    .foregroundColor: UIColor(white: 0.45, alpha: 1)
                ]
                let breedSize = (breedStr as NSString).size(withAttributes: breedAttrs)
                (breedStr as NSString).draw(
                    at: CGPoint(x: (W - breedSize.width) / 2, y: curY),
                    withAttributes: breedAttrs
                )
                curY += breedSize.height + H * 0.018
            }

            UIColor(white: 0.80, alpha: 1).setStroke()
            let divPath = UIBezierPath()
            divPath.move(to: CGPoint(x: W * 0.1, y: curY))
            divPath.addLine(to: CGPoint(x: W * 0.9, y: curY))
            divPath.lineWidth = 1.5
            divPath.stroke()
            curY += H * 0.018

            let infoFont  = UIFont.systemFont(ofSize: W * 0.044, weight: .medium)
            let infoColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)

            func drawInfoLine(_ emoji: String, _ text: String) {
                guard !text.isEmpty else { return }
                let line   = "\(emoji)  \(text)"
                let attrs: [NSAttributedString.Key: Any] = [.font: infoFont, .foregroundColor: infoColor]
                let lSize  = (line as NSString).boundingRect(
                    with: CGSize(width: W * 0.85, height: .greatestFiniteMagnitude),
                    options: .usesLineFragmentOrigin,
                    attributes: attrs, context: nil).size
                (line as NSString).draw(
                    in: CGRect(x: W * 0.075, y: curY, width: W * 0.85, height: lSize.height),
                    withAttributes: attrs
                )
                curY += lSize.height + H * 0.012
            }

            if !pet.location.isEmpty {
                drawInfoLine("📍", pet.location)
            }
            if let lostDate = pet.lostDate {
                let df = DateFormatter()
                df.locale = Locale(identifier: "ru_RU")
                df.dateFormat = "d MMMM yyyy"
                drawInfoLine("📅", "Пропал \(df.string(from: lostDate))")
            }
            if let signs = pet.externalSigns, !signs.isEmpty {
                drawInfoLine("🔍", signs)
            }

            let footerH   = H * 0.10
            let footerY   = H - footerH
            UIColor(red: 0.18, green: 0.18, blue: 0.22, alpha: 1).setFill()
            cgCtx.fill(CGRect(x: 0, y: footerY, width: W, height: footerH))

            let footerFont  = UIFont.systemFont(ofSize: W * 0.040, weight: .semibold)
            let footerAttrs: [NSAttributedString.Key: Any] = [
                .font: footerFont,
                .foregroundColor: UIColor.white
            ]
            let footerStr  = "🐾  Подробнее пишите в приложении Лапки"
            let footerSize = (footerStr as NSString).size(withAttributes: footerAttrs)
            (footerStr as NSString).draw(
                at: CGPoint(x: (W - footerSize.width) / 2, y: footerY + (footerH - footerSize.height) / 2),
                withAttributes: footerAttrs
            )
        }
    }
}

// MARK: - CGRect helper

private extension CGRect {
    func aspectFillRect(for imageSize: CGSize) -> CGRect {
        let scaleX = width  / imageSize.width
        let scaleY = height / imageSize.height
        let scale  = max(scaleX, scaleY)
        let newW   = imageSize.width  * scale
        let newH   = imageSize.height * scale
        return CGRect(
            x: minX + (width  - newW) / 2,
            y: minY + (height - newH) / 2,
            width: newW, height: newH
        )
    }
}
