//
//  ContentView.swift
//  HelloTextKit
//
//  Created by Kyuhyun Park on 2/16/26.
//

import SwiftUI

struct ContentView: View {
    @State var attributedString: AttributedString = ""

    var body: some View {
        VStack {
            Text(attributedString)
            TextEditor(text: $attributedString)
        }
        .padding()
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
