//
//  APIService.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/15.
//

import Foundation

// TODO: Dependencyを使いたいがGenericsを使っているため、うまくInjectできない
protocol APIService {
    func request<T: Decodable>(target: T.Type, url: URL) async throws -> [T]
}

final class APIServiceImpl: APIService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    package func request<T: Decodable>(target: T.Type, url: URL) async throws -> [T] {
        let request = URLRequest(url: url)
        let decoder = JSONDecoder()

        let data: Data
        do {
            (data, _) = try await session.data(for: request)
        } catch {
            throw APIServiceError.responseError
        }

        do {
            return try decoder.decode([T].self, from: data)
        } catch {
            throw APIServiceError.parseError
        }
    }
}

enum APIServiceError: Error {
    case invalidURL
    case parseError
    case responseError
}
