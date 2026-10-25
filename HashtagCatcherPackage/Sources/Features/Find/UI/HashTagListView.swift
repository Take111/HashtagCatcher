//
//  HashTagListView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import SwiftUI
import AlertToast
import UIComponents
import Routing

struct HashTagListView: View {

    @State private var viewModel: HashTagListViewModel
    @State private var isShowToast = false
    @State private var editMode = EditMode.inactive
    @State private var selection = Set<HashTag.ID>()

    @Environment(\.route) private var route

    init(hashTagType: HashTagType) {
        _viewModel = State(initialValue: HashTagListViewModel(hashTagType: hashTagType))
    }
    var body: some View {
        List(viewModel.hashTags, selection: $selection) { hashTag in
            Group {
                if editMode.isEditing {
                    Text(hashTag.title)
                } else {
                    Button(hashTag.title) {
                        viewModel.didSelectHashTag(hashTag)
                        isShowToast.toggle()
                    }
                }
            }
            .frame(height: 48)
        }
        .environment(\.editMode, $editMode)
        .navigationTitle(viewModel.hashTagType.rawValue)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: editMode.isEditing ? "キャンセル" : "選択", bundle: .module)) {
                    setSelecting(!editMode.isEditing)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if editMode.isEditing {
                MainButton(title: String(localized: "グループを作成", bundle: .module)) {
                    route(.createGroup(viewModel.groupDraft(for: selection)))
                    setSelecting(false)
                }
                .disabled(selection.isEmpty)
                .padding()
            }
        }
        .onAppear {
            viewModel.onApper()
        }
        .toast(isPresenting: $isShowToast) {
            AlertToast(displayMode: .hud, type: .regular, title: String(localized: "コピーしました", bundle: .module))
        }
    }

    private func setSelecting(_ isSelecting: Bool) {
        editMode = isSelecting ? .active : .inactive
        selection = []
    }
}

#Preview {
    HashTagListView(hashTagType: .fashion)
}
