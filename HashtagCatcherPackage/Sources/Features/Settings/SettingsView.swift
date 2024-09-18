//
//  SettingsView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/12.
//

import SwiftUI
import UIComponents

package struct SettingsView: View {

    private let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String

    @StateObject var viewModel = SettingsViewModel()

    package init() { }

    package var body: some View {
        NavigationStack {
            VStack {
                List {
                    #if DEBUG
                    HStack {
                        Text("Debug version")
                    }
                    #endif
                    HStack {
                        Text("バージョン")
                        Spacer()
                        Text("\(version ?? "1.0.0")")
                    }
                    HStack {
                        Text("アプリのレビューをする")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.didTappedReview()
                    }
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}
