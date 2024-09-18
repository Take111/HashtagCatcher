//
//  File.swift
//  
//
//  Created by 竹ノ内愛斗 on 2024/09/18.
//

import Foundation

enum HashTagType: String, CaseIterable {
    case popular = "人気"
    case beauty = "美容"
    case fashion = "ファッション"
    case food = "食事"
    case travel = "旅行"

    var hastTags: [HashTag] {
        switch self {
        case .popular:
            return [HashTag(title: "love"),
                    HashTag(title: "fashion"),
                    HashTag(title: "beautiful"),
                    HashTag(title: "happy"),
                    HashTag(title: "follow"),
                    HashTag(title: "cute"),
                    HashTag(title: "me"),
                    HashTag(title: "instagram"),
                    HashTag(title: "いいね"),
                    HashTag(title: "いいね返し"),
                    HashTag(title: "フォロー"),
                    HashTag(title: "フォローミー")]
        case .beauty:
            return [HashTag(title: "beauty"),
                    HashTag(title: "makeup"),
                    HashTag(title: "style"),
                    HashTag(title: "model"),
                    HashTag(title: "cute"),
                    HashTag(title: "girl"),
                    HashTag(title: "ショートカット"),
                    HashTag(title: "ロングヘア"),
                    HashTag(title: "コスメ"),
                    HashTag(title: "春メイク"),
                    HashTag(title: "メイク")]
        case .fashion:
            return [HashTag(title: "fashion"),
                    HashTag(title: "ミリタリーコーデ"),
                    HashTag(title: "ストライプシャツ"),
                    HashTag(title: "大人カジュアル"),
                    HashTag(title: "カジュアル"),
                    HashTag(title: "古着"),
                    HashTag(title: "モード"),
                    HashTag(title: "スタイリッシュ"),
                    HashTag(title: "プチプラ"),
                    HashTag(title: "シンプルコーデ"),
                    HashTag(title: "Tシャツ"),
                    HashTag(title: "ジーンズ")]
        case .food:
            return [HashTag(title: "food"),
                    HashTag(title: "丁寧な暮らし"),
                    HashTag(title: "オムライス"),
                    HashTag(title: "おうちごはん"),
                    HashTag(title: "うちごはん"),
                    HashTag(title: "手料理"),
                    HashTag(title: "和菓子"),
                    HashTag(title: "洋菓子"),
                    HashTag(title: "お茶"),
                    HashTag(title: "ちょっと贅沢")]
        case .travel:
            return [HashTag(title: "travel"),
                    HashTag(title: "tabijo"),
                    HashTag(title: "ふぁいんだー越しの私の世界"),
                    HashTag(title: "海外旅行"),
                    HashTag(title: "国内旅行"),
                    HashTag(title: "海外旅行好きな人と繋がりたい"),
                    HashTag(title: "旅の思い出"),
                    HashTag(title: "旅"),
                    HashTag(title: "旅好き"),
                    HashTag(title: "自然が好き"),
                    HashTag(title: "都会が好き")]
        }
    }
}
