//
//  HashTagListView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import SwiftUI
import AlertToast

struct HashTagListView: View {

    @StateObject var viewModel: HashTagListViewModel
    @State private var isShowToast = false

    init(hashTagType: HashTagType) {
        _viewModel = StateObject(wrappedValue: HashTagListViewModel(hashTagType: hashTagType))
    }
    var body: some View {
        List {
            ForEach(viewModel.hashTags, id: \.udid) { hashTag in
                HStack {
                    Button(action: {
                        viewModel.didSelectHashTag(hashTag)
                        isShowToast.toggle()
                    }, label: {
                        Text(hashTag.title)
                    })
                }.frame(height: 48)
            }
            .navigationTitle(viewModel.hashTagType.rawValue)
        }
        .onAppear {
            viewModel.onApper()
        }
        .toast(isPresenting: $isShowToast) {
            AlertToast(displayMode: .hud, type: .regular, title: "コピーしました")
        }
    }
}

#Preview {
    HashTagListView(hashTagType: .fashion)
}
