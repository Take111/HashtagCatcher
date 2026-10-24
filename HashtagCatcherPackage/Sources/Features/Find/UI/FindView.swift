//
//  FindView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/11.
//

import SwiftUI

package struct FindView: View {
    @State private var viewModel = FindViewModel()

    package init() {

    }

    package var body: some View {
        NavigationStack {
            List(viewModel.types, id: \.self) { type in
                NavigationLink(type.rawValue, value: type)
                    .frame(height: 56)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: HashTagType.self) { type in
                HashTagListView(hashTagType: type)
            }
        }
    }
}

#Preview {
    FindView()
}
