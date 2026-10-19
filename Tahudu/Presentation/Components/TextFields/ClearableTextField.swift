//
//  ClearableTextField.swift
//  Tahudu
//

import SwiftUI

struct ClearableTextFieldStyle: TextFieldStyle {
    @Binding var text: String
    @Binding var focused: Bool
    var symbol: String?

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .modifier(TextFieldClearButton(text: $text, symbol: symbol))
            .multilineTextAlignment(.leading)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(focused ? Color.accentColor : Color(UIColor.lightGray), lineWidth: 1))
    }
}

struct ClearableTextField: View {
    @State private var editing = false

    @Binding var text: String
    let label: String
    let symbol: String?
    var onEditingChanged: ((Bool) -> Void)?

    var body: some View {
        TextField(label, text: $text, onEditingChanged: { edit in
            self.editing = edit
            onEditingChanged?(edit)
        })
        .textFieldStyle(ClearableTextFieldStyle(text: $text, focused: $editing, symbol: symbol))
    }

    init(label: String,
         symbol: String? = nil,
         text: Binding<String>,
         onEditingChanged: ((Bool) -> Void)? = nil) {
        self.label = label
        self.symbol = symbol
        _text = text
        self.onEditingChanged = onEditingChanged
    }
}

struct TextFieldClearButton: ViewModifier {
    @Environment(\.layoutDirection) var direction
    @Binding var text: String
    var symbol: String?

    func body(content: Content) -> some View {
        HStack {
            if let icon = symbol {
                Image(systemName: icon).foregroundColor(Color(UIColor.lightGray))
            }
            content
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }, label: {
                    Image(systemName: direction == .leftToRight ? "delete.left" : "delete.right")
                        .foregroundColor(.accentColor)
                })
            }
        }
    }
}

