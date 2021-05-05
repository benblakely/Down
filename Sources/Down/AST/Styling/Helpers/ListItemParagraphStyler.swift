//
//  ParagraphStyler.swift
//  Down
//
//  Created by John Nguyen on 25.06.19.
//  Copyright © 2016-2019 Down. All rights reserved.
//

#if !os(watchOS) && !os(Linux)

#if canImport(UIKit)

import UIKit

#elseif canImport(AppKit)

import AppKit

#endif

/// A convenient class used to format lists, such that list item prefixes
/// are right aligned and list item content left aligns.

public class ListItemParagraphStyler {

    // MARK: - Properties

    public var indentation: CGFloat {
        return largestPrefixWidth + options.spacingAfterPrefix
    }

    /// The paragraph style intended for the first paragraph.

    public var leadingParagraphStyle: NSParagraphStyle {
        let contentIndentation = indentation
        let style = baseStyle
        style.tabStops = [
            tabStop(at: largestPrefixWidth, textAlignment: .right),
            tabStop(at: contentIndentation, textAlignment: .left)
        ]
        style.defaultTabInterval = options.spacingAfterPrefix
        style.headIndent = contentIndentation
        return style
    }

    /// The paragraph style intended for all paragraphs excluding the first.

    public var trailingParagraphStyle: NSParagraphStyle {
        let contentIndentation = indentation
        let style = baseStyle
        style.firstLineHeadIndent = contentIndentation
        style.headIndent = contentIndentation
        return style
    }

    private let options: ListItemOptions
    private let largestPrefixWidth: CGFloat

    private var baseStyle: NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.paragraphSpacingBefore = options.spacingAbove
        style.paragraphSpacing = options.spacingBelow
        return style
    }

    // MARK: - Life cycle

    public init(options: ListItemOptions, prefixFont: DownFont) {
        self.options = options
        self.largestPrefixWidth = prefixFont.widthOfNumberedPrefix(digits: options.maxPrefixDigits)
    }

    // MARK: - Methods

    private func tabStop(at location: CGFloat, textAlignment: NSTextAlignment) -> NSTextTab {
        return NSTextTab(textAlignment: textAlignment, location: location, options: [:])
    }

}

// MARK: - Helpers

private extension DownFont {

    func widthOfNumberedPrefix(digits: UInt) -> CGFloat {
        return widthOfLargestDigit * CGFloat(digits) + widthOfPeriod
    }

    private var widthOfLargestDigit: CGFloat {
        return Int.decimalDigits
            .map { NSAttributedString(string: "\($0)", attributes: [.font: self]).size().width }
            .max()!
    }

    private var widthOfPeriod: CGFloat {
        return NSAttributedString(string: ".", attributes: [.font: self])
            .size()
            .width
    }

}

private extension Int {

    static var decimalDigits: [Int] {
        return Array(0...9)
    }

}

#endif
