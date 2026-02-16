//
//  CustomTextEditor.swift
//  BrowseTextFiles
//
//  Created by Kyuhyun Park on 7/26/25.
//


import SwiftUI

struct CustomTextEditor: NSViewRepresentable {
    @Binding var text: String

    @Environment(SettingsModel.self) var settings

    func makeNSView(context: Context) -> NSScrollView {
        let textView = makeTextView()
        let scrollView = makeScrollView(for: textView)

        // configureForNoWrap(textView, scrollView)
        textView.delegate = context.coordinator
//        textView.string = text

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }

        if textView.string != text {
            textView.string = text
        }

        guard let font = NSFont(name: settings.fontName, size: settings.fontSize) else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = settings.lineSpacing

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]

        textView.typingAttributes = attributes
        textView.textStorage?.setAttributes(attributes, range: NSRange(location: 0, length: textView.string.count))
    }

    /*
    func makeAttr() -> [NSAttributedString.Key : Any] {
        let defautFont = NSFont.systemFont(ofSize: settings.fontSize)
        let font = NSFont(name: settings.fontName, size: settings.fontSize) ?? defautFont

        let lineHeightMultiple = 1.7

        let fontHeight = font.ascender + abs(font.descender) // + font.leading
        let lineHeight = fontHeight * lineHeightMultiple
        let baselineOffset = (lineHeight - fontHeight) / 2

        // lineSpacing 을 쓰면 Enter 후 빈줄에서 커서가 커지는 현상이 발생한다.
        // 문자를 입력하면 다시 줄어든다.

        // lineHeightMultiple 을 쓰면 커서가 위로 삐죽이 올라온다.

        // minimumLineHeight 를 주고 baselineOffset 을 조절하는 것이 무난해 보인다.

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.0
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        let attr: [NSAttributedString.Key : Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: baselineOffset,
            .foregroundColor: NSColor.textColor,
            .backgroundColor: NSColor.textBackgroundColor,
        ]

        return attr
    }
     */

    func makeTextView() -> NSTextView {
        let layoutManager = NSTextLayoutManager()
        let textContainer = NSTextContainer()
        layoutManager.textContainer = textContainer
        let contentStorage = NSTextContentStorage()
        contentStorage.addTextLayoutManager(layoutManager)
        // let textStorage = contentStorage.textStorage!

        let textView = NSTextView(frame: .zero, textContainer: textContainer)

        textView.autoresizingMask = [.width, .height] // 필수다.
        // textView.textContainerInset = NSSize(width: 8, height: 8) // 패딩

        textView.isEditable = true
        textView.isSelectable = true

        textView.isRichText = false
        textView.importsGraphics = false

        // 사용자 입력에 따라 컨트롤이 계속 커지게 만들려면 true.
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false // **
        textView.maxSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )

        // Wrap 모드면 true
        textContainer.widthTracksTextView = true // **
        textContainer.size = NSSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )

        return textView
    }

    func makeScrollView(for textView: NSView) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.documentView = textView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        return scrollView
    }

    func configureForNoWrap(_ textView: NSTextView, _ scrollView: NSScrollView) {
        let textContainer = textView.textContainer!

        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = true // **

        textContainer.widthTracksTextView = false

        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true // **
    }

    func configureForNoScroller(_ textView: NSTextView) {
        let textContainer = textView.textContainer!

        textView.isVerticallyResizable = false // **
        textView.isHorizontallyResizable = false

        textContainer.widthTracksTextView = false // **
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var view: CustomTextEditor

        init(_ view: CustomTextEditor) {
            self.view = view
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            self.view.text = textView.string
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}
