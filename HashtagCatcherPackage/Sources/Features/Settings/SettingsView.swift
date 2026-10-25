//
//  SettingsView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/12.
//

import SwiftUI
import UIComponents

package struct SettingsView: View {

    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    @State private var viewModel = SettingsViewModel()

    package init() { }

    package var body: some View {
        NavigationStack {
            List {
                #if DEBUG
                Text(verbatim: "Debug version")
                #endif
                HStack {
                    Text("バージョン", bundle: .module)
                    Spacer()
                    Text(version ?? "1.0.0")
                }
                Button {
                    viewModel.didTappedReview()
                } label: {
                    HStack {
                        Text("アプリのレビューをする", bundle: .module)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                .foregroundStyle(.primary)
            }
            .navigationTitle(Text("設定", bundle: .module))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}
