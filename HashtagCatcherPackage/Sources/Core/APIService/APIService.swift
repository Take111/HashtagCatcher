//
//  APIService.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/15.
//

import Foundation
import Dependencies

// TODO: Dependencyを使いたいがGenericsを使っているため、うまくInjectできない
protocol APIService {
    func request<T: Decodable>(target: T.Type, url: URL) async throws -> [T]
}

final class APIServiceImpl: APIService {
    @Dependency(\.urlSession) private var session

    package func request<T: Decodable>(target: T.Type, url: URL) async throws -> [T] {
        guard let (data, _) = try? await session.data(from: url) else { throw APIServiceError.responseError }
        guard let items = try? JSONDecoder().decode([T].self, from: data) else { throw APIServiceError.parseError }
        return items
    }
}

enum APIServiceError: Error {
    case invalidURL
    case parseError
    case responseError
}
