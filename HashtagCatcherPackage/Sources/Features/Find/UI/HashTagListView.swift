//
//  HashTagListView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import SwiftUI

struct HashTagListView: View {

    @StateObject var viewModel: HashTagListViewModel

    init(hashTagType: HashTagType) {
        _viewModel = StateObject(wrappedValue: HashTagListViewModel(hashTagType: hashTagType))
    }
    var body: some View {
        List {
            ForEach(viewModel.hashTags, id: \.udid) { hashTag in
                HStack {
                    Button(action: {
//                        viewModel.didSelectHashTag(hashTag)
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
    }
}

#Preview {
    HashTagListView(hashTagType: .fashion)
        .previewLayout(PreviewLayout.sizeThatFits)
}
