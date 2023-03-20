import XCTest
@testable import GoogleMapsGeoCodingSwift

final class GoogleMapsGeoCodingSwiftTests: XCTestCase {
    func testRequest() {
        let networkService = DefaultGeoCodingNetworkService(key: "Type your API key")
        let expectation = self.expectation(description: "network")
        networkService.request(with: .init(address: "masan"), EndPoint.default) { result in
            switch result {
            case .success(let data):
                print(String(data: data, encoding: .utf8)!)
                expectation.fulfill()
            case .failure(let error):
                print(String(describing: error))
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
    
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    func testAsyncRequest() async throws {
        let networkService = DefaultGeoCodingNetworkService(key: "Type your API key")
        let data = try await networkService.request(with: .init(address: "masan"), EndPoint.default)
        print(String(data: data, encoding: .utf8)!)
    }
}
