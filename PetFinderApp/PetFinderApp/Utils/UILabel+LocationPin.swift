//
//  UILabel+LocationPin.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 01.09.2025.
//


import UIKit

extension UILabel {
    func setLocationText(_ text: String) {
        let config = UIImage.SymbolConfiguration(pointSize: (font?.pointSize ?? 17) * 0.9, weight: .medium)
        guard let pinImage = UIImage(systemName: "mappin.circle.fill", withConfiguration: config)?
                .withTintColor(.label, renderingMode: .alwaysOriginal) else {
            self.text = text
            return
        }

        let attachment = NSTextAttachment()
        attachment.image = pinImage
        let iconSize = pinImage.size
        attachment.bounds = CGRect(
            x: 0,
            y: (font.capHeight - iconSize.height) / 2,
            width: iconSize.width,
            height: iconSize.height
        )

        let result = NSMutableAttributedString(attachment: attachment)
        result.append(NSAttributedString(string: " " + text))
        if let f = font {
            result.addAttribute(.font, value: f, range: NSRange(location: 0, length: result.length))
        }
        attributedText = result
    }
}
