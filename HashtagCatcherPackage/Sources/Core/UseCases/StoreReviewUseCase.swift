//
//  StoreReviewUseCase.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/15.
//

import Foundation
import StoreKit
import Dependencies

package struct StoreReviewUseCase {
    package var showStoreReview: () -> Void
    package var moveAppStoreReview: () -> Void
}

extension StoreReviewUseCase: DependencyKey {
    package static let liveValue = StoreReviewUseCase(
        showStoreReview: { 
            // 基準日時からの秒数を表示する
            let now = Int(Date.timeIntervalSinceReferenceDate)
            let latestReviewDate = UserDefaults.standard.integer(forKey: "review")

            if latestReviewDate != 0 {
                let interval = (60 * 60 * 24) * 60 // 60日間

                if interval < now - latestReviewDate {
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: scene)
                    }
                    UserDefaults.standard.set(now, forKey: "review")
                }
            } else {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
                UserDefaults.standard.set(now, forKey: "review")
            }
        },
        moveAppStoreReview: {
            guard let reviewURL = URL(string: "https://apps.apple.com/app/id1568648119?action=write-review") else {
                fatalError()
            }
            UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
        }
    )
}

package extension DependencyValues {
    var storeReviewUseCase: StoreReviewUseCase {
        get { self[StoreReviewUseCase.self] }
        set { self[StoreReviewUseCase.self] = newValue }
    }
}

