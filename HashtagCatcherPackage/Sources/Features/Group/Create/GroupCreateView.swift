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
    @State private var hashtags = ""
    @State private var isShowCompleteAlert = false

    @Environment(\.presentationMode) private var presentationMode

    @StateObject var viewModel: GroupCreateViewModel = GroupCreateViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("グループ名")
                        .font(.bold(.body)())
                    TextField("", text: $groupName)
                        .frame(width: 300, height: 32)
                        .overlay(RoundedRectangle(cornerRadius: 8.0)
                            .stroke(Color.gray))
                    Text("ハッシュタグ")
                        .font(.bold(.body)())
                    TextEditor(text: $hashtags)
                        .frame(width: 300, height: 200)
                        .overlay(RoundedRectangle(cornerRadius: 8.0)
                            .stroke(Color.gray))
                    MainButton(title: "保存する") {
//                        viewModel.createGroup(name: groupName, hashtag: hashtags)
                        isShowCompleteAlert.toggle()
                    }
                    .alert(isPresented: $isShowCompleteAlert) {
                        Alert(title: Text("保存が完了しました"),
                              dismissButton: .default(Text("OK"), action: {
                                  presentationMode.wrappedValue.dismiss()
                              }))
                    }
                }
                .onAppear {
//                    viewModel.setUseCase(useCase)
                }
                .toolbar(content: {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("キャンセル")
                        })
                    }
                })
                .navigationTitle("グループを作成")
                .navigationBarTitleDisplayMode(.inline)
                .padding()
            }
        }
        .accentColor(Color(UIColor.primary))
    }
}

#Preview {
    GroupCreateView()
}
