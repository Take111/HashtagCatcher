//
//  SettingsViewModel.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/16.
//

import Foundation
import UseCases
import Dependencies

@MainActor
@Observable
final class SettingsViewModel {

    @ObservationIgnored
    @Dependency(\.storeReviewUseCase) private var storeReviewUseCase

    func didTappedReview() {
        storeReviewUseCase.moveAppStoreReview()
    }
}
