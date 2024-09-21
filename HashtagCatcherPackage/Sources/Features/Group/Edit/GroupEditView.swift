//
//  GroupEditView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/16.
//

import SwiftUI

struct GroupEditView: View {
    @State private var groupName = ""
    @State private var hashtags = ""
    @State private var isShowCompleteAlert = false
    @State private var isShowToast = false

    @Environment(\.presentationMode) private var presentationMode

    //    @EnvironmentObject var useCase: HashTagGroupUseCaseImpl
    //    @EnvironmentObject var toastStore: ToastViewStore

    @StateObject var viewModel: GroupEditViewModel = GroupEditViewModel()

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
                    //                    MainButton(title: "コピーする") {
                    //                        viewModel.didTappedPasteButton()
                    //                        isShowToast.toggle()
                    //                    }
                    //                    SemiMainButton(title: "変更する") {
                    //                        viewModel.didTappedEditButton()
//                    isShowCompleteAlert.toggle()
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
        .onAppear {
            //                viewModel.configure(useCase: useCase, store: toastStore)
        }
        .padding()
    }
}


#Preview {
    GroupEditView()
}
