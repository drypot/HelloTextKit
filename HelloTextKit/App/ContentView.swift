//
//  ContentView.swift
//  HelloTextKit
//
//  Created by Kyuhyun Park on 2/16/26.
//

import SwiftUI

struct ContentView: View {
    enum Menu: String, CaseIterable, Identifiable {
        case text = "Text"
        case textEditor = "TextEditor"
        case customTextEditor = "CustomTextEditor"

        var id: String { self.rawValue }
    }

    @State private var selectedMenu: Menu = .text
    @State private var sampleAttrString: AttributedString = ""
    @State private var sampleString: String = ""

    @Environment(SettingsModel.self) var settings

    var body: some View {
        NavigationSplitView {
            List(Menu.allCases, selection: $selectedMenu) { menu in
                NavigationLink(value: menu) {
                    Text(menu.rawValue)
                }
            }
            .navigationTitle("Hello TextKit")
        } detail: {
            switch selectedMenu {
            case .text:
                Text(sampleString)
                    .font(.custom(settings.fontName, size: settings.fontSize))
                    .lineSpacing(settings.lineSpacing)
                    .padding()
            case .textEditor:
                TextEditor(text: $sampleString)
                    .font(.custom(settings.fontName, size: settings.fontSize))
                    .lineSpacing(settings.lineSpacing)
                    .padding()
            case .customTextEditor:
                CustomTextEditor(text: $sampleString)
                    .padding()
            }
        }
        .onAppear {
            // sampleAttrString = loadRTF()
            sampleString = loadSampleText()
        }
    }

    func loadRTF() -> AttributedString {
        guard let url = Bundle.main.url(forResource: "menu", withExtension: "rtf") else {
            return AttributedString("file not found.")
        }

        do {
            let data = try Data(contentsOf: url)
            let nsString = try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.rtf],
                documentAttributes: nil
            )
            return AttributedString(nsString)
        } catch {
            return AttributedString("file loading failed.")
        }
    }

    func loadSampleText() -> String {
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "txt") else {
            return "file not found."
        }

        do {
            let contents = try String(contentsOf: url, encoding: .utf8)
            return contents
        } catch {
            return "file loading failed."
        }
    }
}

#Preview {
    ContentView()
}
