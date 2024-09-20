//
//  SettingsViewModel.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/16.
//

import Foundation
import UseCases
import Dependencies

final class SettingsViewModel: ObservableObject {

    @Dependency(\.storeReviewUseCase) private var storeReviewUseCase

    func didTappedReview() {
        storeReviewUseCase.moveAppStoreReview()
    }
}
