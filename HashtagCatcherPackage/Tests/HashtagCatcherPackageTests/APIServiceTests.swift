import XCTest
@testable import APIService

final class APIServiceTests: XCTestCase {
    private struct Item: Decodable, Equatable {
        let name: String
    }

    private let url = URL(string: "https://example.com/items")!

    override func tearDown() {
        StubURLProtocol.handler = nil
        super.tearDown()
    }

    func testRequestDecodesArray() async throws {
        StubURLProtocol.handler = { request in
            (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!,
             Data(#"[{"name":"travel"},{"name":"food"}]"#.utf8))
        }
        let items = try await makeService().request(target: Item.self, url: url)
        XCTAssertEqual(items, [Item(name: "travel"), Item(name: "food")])
    }

    func testRequestMapsDecodingFailureToParseError() async {
        StubURLProtocol.handler = { request in
            (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!,
             Data("not json".utf8))
        }
        do {
            _ = try await makeService().request(target: Item.self, url: url)
            XCTFail("Expected parseError")
        } catch {
            XCTAssertEqual(error as? APIServiceError, .parseError)
        }
    }

    func testRequestMapsTransportFailureToResponseError() async {
        StubURLProtocol.handler = { _ in throw URLError(.notConnectedToInternet) }
        do {
            _ = try await makeService().request(target: Item.self, url: url)
            XCTFail("Expected responseError")
        } catch {
            XCTAssertEqual(error as? APIServiceError, .responseError)
        }
    }

    private func makeService() -> APIServiceImpl {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return APIServiceImpl(session: URLSession(configuration: configuration))
    }
}

private final class StubURLProtocol: URLProtocol {
    static var handler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        do {
            guard let handler = Self.handler else { throw URLError(.unknown) }
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
