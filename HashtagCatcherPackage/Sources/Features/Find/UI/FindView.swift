//
//  FindView.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/11.
//

import SwiftUI
import UIComponents

package struct FindView: View {
    @State private var isPresentedCilpboard = false

    @StateObject var viewModel: FindViewModel = FindViewModel()

    package init() {

    }

    package var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack {
                    List {
                        ForEach(0 ..< viewModel.types.count, id: \.self) { num in
                            HStack {
                                Text(viewModel.types[num].rawValue)
                                NavigationLink(
                                    destination: HashTagListView(hashTagType: viewModel.types[num]),
                                    label: {
                                        Text("")
                                    }
                                )
                            }
                            .frame(height: 56)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(UIColor.background))
            }
        }
    }
}

#Preview {
    FindView()
}
