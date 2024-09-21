//
//  SemiMainButton.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/21.
//

import Foundation
import SwiftUI

package struct SemiMainButton: View {
    private let titleText: String

    var handler: (() -> Void)?

    package init(title: String, handler: (() -> Void)? = nil) {
        titleText = title
        self.handler = handler
    }

    package var body: some View {
        Button(action: {
            handler?()
        }, label: {
            HStack {
                Text(titleText)
                    .font(.bold(.body)())
                    .foregroundColor(Color(UIColor.primary))
            }
            .frame(width: 240, height: 56)
        })
            .background(Color.white)
            .foregroundColor(.white)
            .cornerRadius(16.0)
    }
}

#Preview {
    SemiMainButton(title: "", handler: nil)
}
