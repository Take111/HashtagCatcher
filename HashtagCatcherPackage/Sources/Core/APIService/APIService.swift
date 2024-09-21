//
//  APIService.swift
//
//
//  Created by 竹ノ内愛斗 on 2024/09/15.
//

import Combine
import Foundation

// TODO: Dependencyを使いたいがGenericsを使っているため、うまくInjectできない
protocol APIService {
    func request<T: Decodable>(target: T.Type, url: URL) -> AnyPublisher<[T], APIServiceError>
}

final class APIServiceImpl: APIService {
    package func request<T: Decodable>(target: T.Type, url: URL) -> AnyPublisher<[T], APIServiceError> {
        let request = URLRequest(url: url)
        let decoder = JSONDecoder()

        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, _ in data }
            .mapError { _ in APIServiceError.responseError }
            .decode(type: [T].self, decoder: decoder)
            .mapError { _ in APIServiceError.parseError }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

enum APIServiceError: Error {
    case invalidURL
    case parseError
    case responseError
}
