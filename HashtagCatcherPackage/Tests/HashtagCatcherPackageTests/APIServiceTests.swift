import XCTest
import Dependencies
@testable import APIService

final class APIServiceTests: XCTestCase {
    private struct Item: Decodable, Equatable {
        let name: String
    }

    override func tearDown() {
        StubURLProtocol.handler = nil
        super.tearDown()
    }

    func testRequestDecodesArray() async throws {
        StubURLProtocol.handler = { _ in Data(#"[{"name":"travel"},{"name":"food"}]"#.utf8) }
        let items = try await makeService().request(target: Item.self, url: URL(string: "https://example.com/items")!)
        XCTAssertEqual(items, [Item(name: "travel"), Item(name: "food")])
    }

    func testRequestMapsDecodingFailureToParseError() async {
        StubURLProtocol.handler = { _ in Data("not json".utf8) }
        let error = await requestError()
        XCTAssertEqual(error as? APIServiceError, .parseError)
    }

    func testRequestMapsTransportFailureToResponseError() async {
        StubURLProtocol.handler = { _ in throw URLError(.notConnectedToInternet) }
        let error = await requestError()
        XCTAssertEqual(error as? APIServiceError, .responseError)
    }

    private func makeService() -> APIServiceImpl {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return withDependencies {
            $0.urlSession = URLSession(configuration: configuration)
        } operation: {
            APIServiceImpl()
        }
    }

    private func requestError() async -> Error? {
        do {
            _ = try await makeService().request(target: Item.self, url: URL(string: "https://example.com/items")!)
        } catch {
            return error
        }
        return nil
    }
}

private final class StubURLProtocol: URLProtocol {
    static var handler: ((URLRequest) throws -> Data)?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        do {
            guard let handler = Self.handler, let url = request.url else { throw URLError(.unknown) }
            let data = try handler(request)
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
