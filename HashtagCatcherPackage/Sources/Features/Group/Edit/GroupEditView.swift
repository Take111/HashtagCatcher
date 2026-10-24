//
//  GroupEditView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/16.
//

import SwiftUI
import UIComponents
import Models
import AlertToast

struct GroupEditView: View {
    @State private var isShowCompleteAlert = false
    @State private var isShowToast = false

    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: GroupEditViewModel

    init(group: HashTagGroupDoc) {
        _viewModel = State(initialValue: GroupEditViewModel(group: group))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                GroupFormFields(groupName: $viewModel.groupName, hashtags: $viewModel.hashtags)
                MainButton(title: "コピーする") {
                    viewModel.onTapPasteButton()
                    isShowToast.toggle()
                }
                SemiMainButton(title: "変更する") {
                    viewModel.onTapEditButton()
                    isShowCompleteAlert.toggle()
                }
                .alert("変更が完了しました", isPresented: $isShowCompleteAlert) {
                    Button("OK") {
                        dismiss()
                    }
                }
            }
        }
        .padding()
        .toast(isPresenting: $isShowToast) {
            AlertToast(displayMode: .hud, type: .regular, title: "コピーしました")
        }
    }
}


#Preview {
    GroupEditView(group: HashTagGroupDoc(name: "", tags: "", createdAt: nil))
}
