//
//  GroupView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/12.
//

import SwiftUI
import UIComponents
import Models

package struct GroupView: View {

    @State private var isPresentedEditView = false

    @State private var viewModel = GroupViewModel()

    package init() { }

    package var body: some View {
        NavigationStack {
            Group {
                if !viewModel.groups.isEmpty {
                    List {
                        ForEach(viewModel.groups) { group in
                            NavigationLink(group.name, value: group)
                                .frame(height: 48)
                        }
                        .onDelete { indexSet in
                            guard let row = indexSet.first else { return }
                            viewModel.deleteGroup(viewModel.groups[row])
                        }
                    }
                } else {
                    VStack(alignment: .center) {
                        Spacer()
                        Text("右上のボタンから、グループを作成しよう")
                            .font(.callout)
                        Spacer()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentedEditView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: HashTagGroupDoc.self) { group in
                GroupEditView(group: group, onUpdateGroup: {
                    viewModel.onAppear()
                })
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .fullScreenCover(isPresented: $isPresentedEditView) {
            GroupCreateView(onCreateGroup: {
                viewModel.onAppear()
            })
        }
    }
}

#Preview {
    GroupView()
}
