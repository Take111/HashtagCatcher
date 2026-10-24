//
//  GroupCreateView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/16.
//

import SwiftUI
import UIComponents
import Routing

struct GroupCreateView: View {
    @State private var draft: GroupDraft
    @State private var isShowCompleteAlert = false

    @Environment(\.dismiss) private var dismiss

    @State private var viewModel = GroupCreateViewModel()

    private let onCreateGroup: () -> Void

    init(draft: GroupDraft, onCreateGroup: @escaping () -> Void) {
        _draft = State(initialValue: draft)
        self.onCreateGroup = onCreateGroup
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    GroupFormFields(groupName: $draft.name, hashtags: $draft.hashtags)
                    MainButton(title: String(localized: "保存する", bundle: .module)) {
                        viewModel.onTapSaveButton(groupName: draft.name, hashTags: draft.hashtags)
                        isShowCompleteAlert.toggle()
                        onCreateGroup()
                    }
                    .alert(Text("保存が完了しました", bundle: .module), isPresented: $isShowCompleteAlert) {
                        Button(String(localized: "OK", bundle: .module)) {
                            dismiss()
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(String(localized: "キャンセル", bundle: .module)) {
                            dismiss()
                        }
                    }
                }
                .navigationTitle(Text("グループを作成", bundle: .module))
                .navigationBarTitleDisplayMode(.inline)
                .padding()
            }
        }
        .tint(Color(UIColor.primary))
    }
}

#Preview {
    GroupCreateView(draft: GroupDraft(), onCreateGroup: {})
}
