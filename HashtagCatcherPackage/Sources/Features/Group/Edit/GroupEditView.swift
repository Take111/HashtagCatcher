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
                MainButton(title: String(localized: "コピーする", bundle: .module)) {
                    viewModel.onTapPasteButton()
                    isShowToast.toggle()
                }
                SemiMainButton(title: String(localized: "変更する", bundle: .module)) {
                    viewModel.onTapEditButton()
                    isShowCompleteAlert.toggle()
                }
                .alert(Text("変更が完了しました", bundle: .module), isPresented: $isShowCompleteAlert) {
                    Button(String(localized: "OK", bundle: .module)) {
                        dismiss()
                    }
                }
            }
        }
        .padding()
        .toast(isPresenting: $isShowToast) {
            AlertToast(displayMode: .hud, type: .regular, title: String(localized: "コピーしました", bundle: .module))
        }
    }
}


#Preview {
    GroupEditView(group: HashTagGroupDoc(name: "", tags: "", createdAt: nil))
}
