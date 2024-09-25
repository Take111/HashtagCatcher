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
    @State private var groupName = ""
    @State private var hashtags = ""
    @State private var isShowCompleteAlert = false
    @State private var isShowToast = false

    @Environment(\.presentationMode) private var presentationMode

    @StateObject var viewModel: GroupEditViewModel

    init(group: HashTagGroupDoc) {
        _viewModel = StateObject(wrappedValue: GroupEditViewModel(group: group))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("グループ名")
                    .font(.bold(.body)())
                TextField("", text: $viewModel.groupName)
                    .frame(width: 300, height: 32)
                    .overlay(RoundedRectangle(cornerRadius: 8.0)
                        .stroke(Color.gray))
                Text("ハッシュタグ")
                    .font(.bold(.body)())
                TextEditor(text: $viewModel.hashtags)
                    .frame(width: 300, height: 200)
                    .overlay(RoundedRectangle(cornerRadius: 8.0)
                        .stroke(Color.gray))
                VStack(spacing: 24) {
                    MainButton(title: "コピーする") {
                        viewModel.onTapPasteButton()
                        isShowToast.toggle()
                    }
                    SemiMainButton(title: "変更する") {
                        viewModel.onTapEditButton()
                        isShowCompleteAlert.toggle()
                    }
                }
                .alert(isPresented: $isShowCompleteAlert, content: {
                    Alert(title: Text("変更が完了しました"),
                          dismissButton: .default(Text("OK"),
                                                  action: {
                        print("完了")
                        presentationMode.wrappedValue.dismiss()
                    }))
                })
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
