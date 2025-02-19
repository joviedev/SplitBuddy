import XCTest
@testable import SplitBuddy

final class SplitBuddyTests: XCTestCase {

    var exchangeRateTool: ExchangeRatesTools?

    override func setUpWithError() throws {
        try super.setUpWithError()
        exchangeRateTool = ExchangeRatesTools.shared
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        exchangeRateTool = nil
    }

    func testSuccessfulExchangeRateFetch() throws {
        let expectation = self.expectation(description: "Fetching exchange rates")
        
        ExchangeRatesTools.shared.getExchangeRates(for: "USD") { result in
            switch result {
            case .success(let json):
                XCTAssertNotNil(json["conversion_rates"], "Exchange rates data should contain conversion rates")
            case .failure(let error):
                XCTFail("Expected successful fetch, but got error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testInvalidCurrencyCode() throws {
        let expectation = self.expectation(description: "Handling invalid currency code")
        
        ExchangeRatesTools.shared.getExchangeRates(for: "INVALID") { result in
            switch result {
            case .success:
                XCTFail("Expected failure for invalid currency code")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be returned for invalid currency code")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testNetworkErrorHandling() throws {
        let expectation = self.expectation(description: "Handling network error")
        
        // Simulate a network error by using an invalid URL
        ExchangeRatesTools.shared.getExchangeRates(for: "USD") { result in
            switch result {
            case .success:
                XCTFail("Expected failure due to network error, but got success")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be returned in case of a network issue")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDefaultBaseCurrencyFetch() throws {
        let expectation = self.expectation(description: "Fetching exchange rates with default base currency")

        ExchangeRatesTools.shared.getExchangeRates { result in
            switch result {
            case .success(let json):
                XCTAssertNotNil(json["conversion_rates"], "Should contain conversion rates for USD")
            case .failure(let error):
                XCTFail("Expected successful fetch for default USD, but got error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testEmptyBaseCurrency() throws {
        let expectation = self.expectation(description: "Fetching exchange rates with empty base currency")

        ExchangeRatesTools.shared.getExchangeRates(for: "") { result in
            switch result {
            case .success:
                XCTFail("Expected failure for empty base currency")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be returned for empty base currency")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testInvalidJSONResponse() throws {
        // Assuming you can simulate or mock a URL that returns invalid JSON
        let expectation = self.expectation(description: "Handling invalid JSON response")

        // Use an invalid or mock URL (handled through a modified URL request)
        ExchangeRatesTools.shared.getExchangeRates(for: "INVALID_JSON") { result in
            switch result {
            case .success:
                XCTFail("Expected failure due to invalid JSON response")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be returned for invalid JSON")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testNoInternetConnection() throws {
        let expectation = self.expectation(description: "Handling no internet connection")

        // Simulate network unavailability or intercept the network request
        ExchangeRatesTools.shared.getExchangeRates(for: "USD") { result in
            switch result {
            case .success:
                XCTFail("Expected failure due to no internet connection")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be returned when no internet connection is available")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testNonExistentCurrencyCode() throws {
        let expectation = self.expectation(description: "Handling non-existent currency code")

        ExchangeRatesTools.shared.getExchangeRates(for: "XYZ") { result in
            switch result {
            case .success:
                XCTFail("Expected failure for non-existent currency code")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be returned for non-existent currency code")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSpecialCharactersInCurrencyCode() throws {
        let expectation = self.expectation(description: "Handling special characters in currency code")

        ExchangeRatesTools.shared.getExchangeRates(for: "!@#$") { result in
            switch result {
            case .success:
                XCTFail("Expected failure for special character currency code")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should be returned for special character currency code")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testPerformanceForFetchingExchangeRates() throws {
        measure {
            let expectation = self.expectation(description: "Fetching exchange rates within acceptable time")

            ExchangeRatesTools.shared.getExchangeRates(for: "USD") { result in
                switch result {
                case .success(let json):
                    XCTAssertNotNil(json["conversion_rates"], "Should contain conversion rates for USD")
                case .failure(let error):
                    XCTFail("Expected successful fetch, but got error: \(error)")
                }
                expectation.fulfill()
            }

            waitForExpectations(timeout: 5, handler: nil)
        }
    }

}
