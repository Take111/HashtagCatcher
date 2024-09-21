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

    @StateObject var viewModel = GroupViewModel()

    package init() { }

    package var body: some View {
        NavigationStack {
            if !viewModel.groups.isEmpty {
                ZStack(alignment: .bottom) {
                    List {
                        ForEach(viewModel.groups, id: \.self) { group in
                            HStack {
                                Text(group.name)
                                NavigationLink(
                                    destination:
                                        GroupEditView(group: group),
                                    label: {
                                        Text("")
                                    }
                                )
                            }
                            .frame(height: 48)
                        }
                        .onDelete(perform: { indexSet in
                            guard let row = indexSet.first else { return }
                            viewModel.deleteGroup(viewModel.groups[row])
                        })
                    }
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
                }
            } else {
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
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .fullScreenCover(isPresented: $isPresentedEditView, content: {
            GroupCreateView(onCreateGroup: {
                viewModel.onAppear()
            } )

        })
    }
}

#Preview {
    GroupView()
}
