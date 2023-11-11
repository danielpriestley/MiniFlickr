//
//  HTMLTextView.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 10/11/2023.
//

import UIKit
import SwiftUI

/// This view exists due to some users on flickr utilising html strings in their image descriptions to provide links to other platforms
func isHTML(_ string: String) -> Bool {
    let range = NSRange(location: 0, length: string.utf16.count)
    let regex = try! NSRegularExpression(pattern: "<[a-z][\\s\\S]*>", options: .caseInsensitive)
    return regex.firstMatch(in: string, options: [], range: range) != nil
}

struct HTMLTextView: UIViewRepresentable {
    var htmlString: String
    var font: UIFont
    var textColor: UIColor
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.backgroundColor = .clear
        textView.font = font
        textView.textColor = textColor
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainerInset = .zero
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        let data = Data(htmlString.utf8)
        if let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil) {
            
            attributedString.addAttributes([
                .font: font,
                .foregroundColor: textColor
            ], range: NSRange(location: 0, length: attributedString.length))
            
            uiView.attributedText = attributedString
        }
    }
}
