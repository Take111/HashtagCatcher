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
                    MainButton(title: "保存する") {
                        viewModel.onTapSaveButton(groupName: draft.name, hashTags: draft.hashtags)
                        isShowCompleteAlert.toggle()
                        onCreateGroup()
                    }
                    .alert("保存が完了しました", isPresented: $isShowCompleteAlert) {
                        Button("OK") {
                            dismiss()
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("キャンセル") {
                            dismiss()
                        }
                    }
                }
                .navigationTitle("グループを作成")
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
