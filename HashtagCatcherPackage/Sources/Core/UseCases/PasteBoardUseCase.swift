//
//  PasteBoardUseCase.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/20.
//

import Foundation
import Dependencies
import UIKit

package struct PasteBoardUseCase {
    package var pastText: (_ text: String) -> Void
}

extension PasteBoardUseCase: DependencyKey {
    package static let liveValue = Self(
        pastText: { text in
            UIPasteboard.general.string = text
        }
    )
}

package extension DependencyValues {
    var pasteBoardUseCase: PasteBoardUseCase {
        get { self[PasteBoardUseCase.self] }
        set { self[PasteBoardUseCase.self] = newValue }
    }
}
