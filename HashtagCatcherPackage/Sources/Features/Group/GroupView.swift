//
//  GroupView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/12.
//

import SwiftUI
import UIComponents
import Models
import Routing

package struct GroupView: View {

    @Binding private var createDraft: GroupDraft?

    @State private var viewModel = GroupViewModel()

    package init(createDraft: Binding<GroupDraft?>) {
        _createDraft = createDraft
    }

    package var body: some View {
        NavigationStack {
            Group {
                if viewModel.groups.isEmpty {
                    VStack {
                        Spacer()
                        Text("右上のボタンから、グループを作成しよう")
                            .font(.callout)
                        Spacer()
                    }
                } else {
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
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        createDraft = GroupDraft()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: HashTagGroupDoc.self) { group in
                GroupEditView(group: group)
            }
            // Inside the stack so returning from the edit screen reloads renamed groups.
            .onAppear {
                viewModel.onAppear()
            }
        }
        .fullScreenCover(item: $createDraft) { draft in
            GroupCreateView(draft: draft, onCreateGroup: {
                viewModel.onAppear()
            })
        }
    }
}

#Preview {
    @Previewable @State var createDraft: GroupDraft?
    GroupView(createDraft: $createDraft)
}
