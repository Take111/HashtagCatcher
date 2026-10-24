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
    @State private var groupName: String
    @State private var hashTags: String
    @State private var isShowCompleteAlert = false

    @Environment(\.dismiss) private var dismiss

    @State private var viewModel = GroupCreateViewModel()

    private let onCreateGroup: () -> Void

    init(draft: GroupDraft, onCreateGroup: @escaping () -> Void) {
        _groupName = State(initialValue: draft.name)
        _hashTags = State(initialValue: draft.hashtags)
        self.onCreateGroup = onCreateGroup
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    GroupFormFields(groupName: $groupName, hashtags: $hashTags)
                    MainButton(title: "保存する") {
                        viewModel.onTapSaveButton(groupName: groupName, hashTags: hashTags)
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
