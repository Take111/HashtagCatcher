//
//  GroupView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/12.
//

import SwiftUI
import UIComponents

package struct GroupView: View {

    @State private var isPresentedEditView = false

    package init() {}

    package var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Spacer()
                Text("右上のボタンから、グループを作成しよう")
                    .font(.callout)
                    .toolbar(content: {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            EditButton()
                        }
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button(action: {
                                isPresentedEditView.toggle()
                            }, label: {
                                Image(systemName: "plus")
                            })
                        }
                    })
                    .navigationBarTitleDisplayMode(.inline)
                    .fullScreenCover(isPresented: $isPresentedEditView, content: {
                        GroupCreateView(/*viewModel.init()*/)
                        //                            .onDisappear {
                        ////                                viewModel.onAppear()
                        //                            }
                    })
                    .onAppear {
                        //                        viewModel.setUseCase(useCase)
                        //                        viewModel.onAppear()
                    }
                Spacer()
            }
        }
    }
}

#Preview {
    GroupView()
}
