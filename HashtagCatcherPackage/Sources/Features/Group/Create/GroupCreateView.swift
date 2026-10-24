//
//  GroupCreateView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/16.
//

import SwiftUI
import UIComponents

struct GroupCreateView: View {
    @State private var groupName = ""
    @State private var hashTags = ""
    @State private var isShowCompleteAlert = false

    @Environment(\.dismiss) private var dismiss

    @State private var viewModel = GroupCreateViewModel()

    private let onCreateGroup: () -> Void

    init(onCreateGroup: @escaping () -> Void) {
        self.onCreateGroup = onCreateGroup
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text("グループ名")
                        .font(.body.bold())
                    TextField("", text: $groupName)
                        .frame(width: 300, height: 32)
                        .overlay(RoundedRectangle(cornerRadius: 8.0)
                            .stroke(Color.gray))
                    Text("ハッシュタグ")
                        .font(.body.bold())
                    TextEditor(text: $hashTags)
                        .frame(width: 300, height: 200)
                        .overlay(RoundedRectangle(cornerRadius: 8.0)
                            .stroke(Color.gray))
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
    GroupCreateView(onCreateGroup: {})
}
