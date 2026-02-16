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

        var id: String { self.rawValue }
    }

    @State private var selectedMenu: Menu = .text
    @State private var attributedString: AttributedString = ""

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
                Text(attributedString)
                    .padding()
            case .textEditor:
                TextEditor(text: $attributedString)
                    .padding()
            }
        }
        .onAppear {
            attributedString = loadRTF()
        }
    }

    func loadRTF() -> AttributedString {
        guard let url = Bundle.main.url(forResource: "menu", withExtension: "rtf"),
              let data = try? Data(contentsOf: url) else {
            return AttributedString("file not found.")
        }

        if let nsString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.rtf],
            documentAttributes: nil
        ) {
            return AttributedString(nsString)
        }

        return AttributedString("file loading failed.")
    }
}

#Preview {
    ContentView()
}
