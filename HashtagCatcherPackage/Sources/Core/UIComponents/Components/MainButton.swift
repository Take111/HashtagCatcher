//
//  MainButton.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import SwiftUI

package struct MainButton: View {
    private let titleText: String

    package var handler: (() -> Void)?

    @Environment(\.isEnabled) private var isEnabled

    package init(title: String, handler: (() -> Void)? = nil) {
        titleText = title
        self.handler = handler
    }

    package var body: some View {
        Button {
            handler?()
        } label: {
            Text(titleText)
                .font(.body.bold())
                .frame(width: 240, height: 56)
        }
        .background(isEnabled ? Color(UIColor.primary) : Color(UIColor.systemGray3))
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16.0))
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MainButton(title: "保存する")
}
