//
//  SettingsViewModel.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/16.
//

import Foundation
import UseCases

final class SettingsViewModel: ObservableObject {

    private let useCase: StoreReviewUseCase

    init(useCase: StoreReviewUseCase = StoreReviewUseCaseImpl()) {
        self.useCase = useCase
    }
    
    func didTappedReview() {
        useCase.moveAppStoreReview()
    }
}
