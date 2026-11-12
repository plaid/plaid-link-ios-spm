import LinkKit
import XCTest

@testable import LinkKitObjC
@testable import LinkKitObjCInternal

#if canImport(FinanceKit) && compiler(>=5.10) && !targetEnvironment(macCatalyst)
@available(iOS 17.4, *)
final class PLKPlaidFinanceKitTests: XCTestCase {

    // MARK: - SyncBehavior Tests

    func testSyncBehaviorLiveConvertsToSwift() {
        let objcBehavior = PLKPlaidFinanceKit.PLKSyncBehavior.live
        let swiftBehavior = objcBehavior.swiftValue

        // Verify it converts to the Swift enum properly
        switch swiftBehavior {
        case .live:
            XCTAssertTrue(true, "Correctly converted to .live")
        case .simulated:
            XCTFail("Should have converted to .live, not .simulated")
        @unknown default:
            XCTFail("unknown default")
        }
    }

    func testSyncBehaviorSimulatedConvertsToSwift() {
        let objcBehavior = PLKPlaidFinanceKit.PLKSyncBehavior.simulated
        let swiftBehavior = objcBehavior.swiftValue

        // Verify it converts to the Swift enum properly
        switch swiftBehavior {
        case .simulated:
            XCTAssertTrue(true, "Correctly converted to .simulated")
        case .live:
            XCTFail("Should have converted to .simulated, not .live")
        @unknown default:
            XCTFail("unknown default")
        }
    }

    func testSyncBehaviorRawValues() {
        // Verify the Int raw values are stable
        XCTAssertEqual(PLKPlaidFinanceKit.PLKSyncBehavior.live.rawValue, 0)
        XCTAssertEqual(PLKPlaidFinanceKit.PLKSyncBehavior.simulated.rawValue, 1)
    }

    // MARK: - Status

    func testFinanceKitStatusToObjcCases() {
        XCTAssertEqual(PlaidFinanceKit.Status.unavailable.toObjC, .unavailable)
        XCTAssertEqual(PlaidFinanceKit.Status.notDetermined.toObjC, .notDetermined)
        XCTAssertEqual(PlaidFinanceKit.Status.denied.toObjC, .denied)
        XCTAssertEqual(PlaidFinanceKit.Status.authorized.toObjC, .authorized)
        XCTAssertEqual(PlaidFinanceKit.Status.unknown.toObjC, .unknown)
    }

    func testFinanceKitStatusRawValues() {
        XCTAssertEqual(PLKPlaidFinanceKit.PLKFinanceKitStatus.unavailable.rawValue, 0)
        XCTAssertEqual(PLKPlaidFinanceKit.PLKFinanceKitStatus.notDetermined.rawValue, 1)
        XCTAssertEqual(PLKPlaidFinanceKit.PLKFinanceKitStatus.denied.rawValue, 2)
        XCTAssertEqual(PLKPlaidFinanceKit.PLKFinanceKitStatus.authorized.rawValue, 3)
        XCTAssertEqual(PLKPlaidFinanceKit.PLKFinanceKitStatus.unknown.rawValue, 4)
    }

    // MARK: - FinanceKitError Conversion Tests

    func testInvalidTokenErrorConvertsToObjC() {
        let swiftError = FinanceKitError.invalidToken(message: "Invalid token format")
        let objcError = swiftError.toObjC

        XCTAssertEqual(objcError, .invalidToken)
        XCTAssertEqual(objcError.rawValue, 0)
    }

    func testPermissionErrorConvertsToObjC() {
        let swiftError = FinanceKitError.permissionError(message: "Permission denied")
        let objcError = swiftError.toObjC

        XCTAssertEqual(objcError, .permissionError)
        XCTAssertEqual(objcError.rawValue, 1)
    }

    func testLinkApiErrorConvertsToObjC() {
        let swiftError = FinanceKitError.linkApiError(message: "API request failed")
        let objcError = swiftError.toObjC

        XCTAssertEqual(objcError, .linkApiError)
        XCTAssertEqual(objcError.rawValue, 2)
    }

    func testPermissionAccessErrorConvertsToObjC() {
        let swiftError = FinanceKitError.permissionAccessError(message: "Cannot access permission")
        let objcError = swiftError.toObjC

        XCTAssertEqual(objcError, .permissionAccessError)
        XCTAssertEqual(objcError.rawValue, 3)
    }

    func testUnknownErrorConvertsToObjC() {
        let underlyingError = NSError(domain: "TestDomain", code: 999, userInfo: nil)
        let swiftError = FinanceKitError.unknown(error: underlyingError)
        let objcError = swiftError.toObjC

        XCTAssertEqual(objcError, .unknown)
        XCTAssertEqual(objcError.rawValue, 4)
    }

    // MARK: - NSError Conversion Tests

    func testInvalidTokenErrorConvertsToNSError() {
        let message = "Invalid token format"
        let swiftError = FinanceKitError.invalidToken(message: message)
        let nsError = swiftError.toNSError

        XCTAssertEqual(nsError.domain, kPLKDefaultErrorDomain)
        XCTAssertEqual(nsError.code, PLKPlaidFinanceKitError.invalidToken.rawValue)
        XCTAssertEqual(nsError.userInfo["message"] as? String, message)
        XCTAssertEqual(nsError.localizedDescription, message)
    }

    func testPermissionErrorConvertsToNSError() {
        let message = "Permission denied by user"
        let swiftError = FinanceKitError.permissionError(message: message)
        let nsError = swiftError.toNSError

        XCTAssertEqual(nsError.domain, kPLKDefaultErrorDomain)
        XCTAssertEqual(nsError.code, PLKPlaidFinanceKitError.permissionError.rawValue)
        XCTAssertEqual(nsError.userInfo["message"] as? String, message)
        XCTAssertEqual(nsError.localizedDescription, message)
    }

    func testLinkApiErrorConvertsToNSError() {
        let message = "API request failed with status 500"
        let swiftError = FinanceKitError.linkApiError(message: message)
        let nsError = swiftError.toNSError

        XCTAssertEqual(nsError.domain, kPLKDefaultErrorDomain)
        XCTAssertEqual(nsError.code, PLKPlaidFinanceKitError.linkApiError.rawValue)
        XCTAssertEqual(nsError.userInfo["message"] as? String, message)
        XCTAssertEqual(nsError.localizedDescription, message)
    }

    func testPermissionAccessErrorConvertsToNSError() {
        let message = "Cannot access FinanceKit permission"
        let swiftError = FinanceKitError.permissionAccessError(message: message)
        let nsError = swiftError.toNSError

        XCTAssertEqual(nsError.domain, kPLKDefaultErrorDomain)
        XCTAssertEqual(nsError.code, PLKPlaidFinanceKitError.permissionAccessError.rawValue)
        XCTAssertEqual(nsError.userInfo["message"] as? String, message)
        XCTAssertEqual(nsError.localizedDescription, message)
    }

    func testUnknownErrorConvertsToNSError() {
        let underlyingMessage = "Something went wrong"
        let underlyingError = NSError(
            domain: "TestDomain",
            code: 999,
            userInfo: [NSLocalizedDescriptionKey: underlyingMessage]
        )
        let swiftError = FinanceKitError.unknown(error: underlyingError)
        let nsError = swiftError.toNSError

        XCTAssertEqual(nsError.domain, kPLKDefaultErrorDomain)
        XCTAssertEqual(nsError.code, PLKPlaidFinanceKitError.unknown.rawValue)
        XCTAssertEqual(nsError.userInfo["message"] as? String, underlyingMessage)
        XCTAssertEqual(nsError.localizedDescription, underlyingMessage)
    }

    func testDataUnavailableErrorConvertsToObjC() {
        let swiftError = FinanceKitError.dataUnavailable(message: "unavailable")
        let objcError = swiftError.toObjC

        XCTAssertEqual(objcError, .dataUnavailable)
        XCTAssertEqual(objcError.rawValue, 8)
    }

    func testDataUnavailableErrorToNSError() {
        let nsError = FinanceKitError.dataUnavailable(message: "unavailable").toNSError

        XCTAssertEqual(nsError.domain, kPLKDefaultErrorDomain)
        XCTAssertEqual(nsError.code, PLKPlaidFinanceKitError.dataUnavailable.rawValue)
        XCTAssertEqual(nsError.userInfo["message"] as? String, "unavailable")
        XCTAssertEqual(nsError.localizedDescription, "unavailable")
    }

    func testPermissionNotRequestedErrorConvertsToObjC() {
        let swiftError = FinanceKitError.permissionNotRequested(message: "not requested")
        let objcError = swiftError.toObjC

        XCTAssertEqual(objcError, .permissionNotRequested)
        XCTAssertEqual(objcError.rawValue, 7)
    }

    func testPermissionNotRequestedErrorToNSError() {
        let nsError = FinanceKitError.permissionNotRequested(message: "not requested").toNSError

        XCTAssertEqual(nsError.domain, kPLKDefaultErrorDomain)
        XCTAssertEqual(nsError.code, PLKPlaidFinanceKitError.permissionNotRequested.rawValue)
        XCTAssertEqual(nsError.userInfo["message"] as? String, "not requested")
        XCTAssertEqual(nsError.userInfo[NSLocalizedDescriptionKey] as? String, "not requested")
    }

    func testChannelClosedErrorToNSError() {
        let nsError = FinanceKitError.channelClosed(message: "closed").toNSError

        XCTAssertEqual(nsError.domain, kPLKDefaultErrorDomain)
        XCTAssertEqual(nsError.code, PLKPlaidFinanceKitError.channelClosed.rawValue)
        XCTAssertEqual(nsError.code, 9)
        XCTAssertEqual(nsError.userInfo["message"] as? String, "closed")
        XCTAssertEqual(nsError.localizedDescription, "closed")
    }

    func testSyncTimedOutErrorToNSError() {
        let nsError = FinanceKitError.syncTimedOut(message: "timed out").toNSError

        XCTAssertEqual(nsError.domain, kPLKDefaultErrorDomain)
        XCTAssertEqual(nsError.code, PLKPlaidFinanceKitError.syncTimedOut.rawValue)
        XCTAssertEqual(nsError.code, 10)
        XCTAssertEqual(nsError.userInfo["message"] as? String, "timed out")
        XCTAssertEqual(nsError.localizedDescription, "timed out")
    }

    func testNoAccountsErrorConvertsToObjC() {
        let swiftError = FinanceKitError.noAccounts(message: "no accounts shared")
        let objcError = swiftError.toObjC

        XCTAssertEqual(objcError, .noAccounts)
        XCTAssertEqual(objcError.rawValue, 5)
    }

    func testSyncFailedErrorConvertsToObjC() {
        let swiftError = FinanceKitError.syncFailed(errorType: "t", errorCode: "c", message: "u")
        let objcError = swiftError.toObjC

        XCTAssertEqual(objcError, .syncFailed)
        XCTAssertEqual(objcError.rawValue, 6)
    }

    func testNoAccountsErrorToNSError() {
        let nsError = FinanceKitError.noAccounts(message: "no accounts shared").toNSError

        XCTAssertEqual(nsError.domain, kPLKDefaultErrorDomain)
        XCTAssertEqual(nsError.code, PLKPlaidFinanceKitError.noAccounts.rawValue)
        XCTAssertEqual(nsError.userInfo["message"] as? String, "no accounts shared")
        XCTAssertEqual(nsError.localizedDescription, "no accounts shared")
        XCTAssertNil(nsError.userInfo[kPLKFinanceKitErrorTypeKey])
        XCTAssertNil(nsError.userInfo[kPLKFinanceKitErrorCodeKey])
    }

    func testSyncFailedErrorToNSErrorCarriesTypeAndCode() {
        let swiftError = FinanceKitError.syncFailed(
            errorType: "ITEM_ERROR",
            errorCode: "ITEM_LOGIN_REQUIRED",
            message: "login required"
        )
        let nsError = swiftError.toNSError

        XCTAssertEqual(nsError.domain, kPLKDefaultErrorDomain)
        XCTAssertEqual(nsError.code, PLKPlaidFinanceKitError.syncFailed.rawValue)
        XCTAssertEqual(nsError.userInfo["message"] as? String, "login required")
        XCTAssertEqual(nsError.localizedDescription, "login required")
        XCTAssertEqual(nsError.userInfo[kPLKFinanceKitErrorTypeKey] as? String, "ITEM_ERROR")
        XCTAssertEqual(nsError.userInfo[kPLKFinanceKitErrorCodeKey] as? String, "ITEM_LOGIN_REQUIRED")
    }

    // MARK: - PLKPlaidFinanceKitError Raw Values

    func testPlaidFinanceKitErrorRawValues() {
        // Ensure enum raw values are stable for Objective-C compatibility
        XCTAssertEqual(PLKPlaidFinanceKitError.invalidToken.rawValue, 0)
        XCTAssertEqual(PLKPlaidFinanceKitError.permissionError.rawValue, 1)
        XCTAssertEqual(PLKPlaidFinanceKitError.linkApiError.rawValue, 2)
        XCTAssertEqual(PLKPlaidFinanceKitError.permissionAccessError.rawValue, 3)
        XCTAssertEqual(PLKPlaidFinanceKitError.unknown.rawValue, 4)
        XCTAssertEqual(PLKPlaidFinanceKitError.noAccounts.rawValue, 5)
        XCTAssertEqual(PLKPlaidFinanceKitError.syncFailed.rawValue, 6)
        XCTAssertEqual(PLKPlaidFinanceKitError.permissionNotRequested.rawValue, 7)
        XCTAssertEqual(PLKPlaidFinanceKitError.dataUnavailable.rawValue, 8)
        XCTAssertEqual(PLKPlaidFinanceKitError.channelClosed.rawValue, 9)
        XCTAssertEqual(PLKPlaidFinanceKitError.syncTimedOut.rawValue, 10)
    }

    // MARK: - Integration Tests

    func testAllErrorTypesConvertCorrectly() {
        let testCases: [(FinanceKitError, PLKPlaidFinanceKitError)] = [
            (.invalidToken(message: "test"), .invalidToken),
            (.permissionError(message: "test"), .permissionError),
            (.linkApiError(message: "test"), .linkApiError),
            (.permissionAccessError(message: "test"), .permissionAccessError),
            (.permissionNotRequested(message: "test"), .permissionNotRequested),
            (.dataUnavailable(message: "test"), .dataUnavailable),
            (.noAccounts(message: "test"), .noAccounts),
            (.syncFailed(errorType: "t", errorCode: "c", message: "test"), .syncFailed),
            (.channelClosed(message: "test"), .channelClosed),
            (.syncTimedOut(message: "test"), .syncTimedOut),
            (.unknown(error: NSError(domain: "test", code: 0)), .unknown),
        ]

        for (swiftError, expectedObjcError) in testCases {
            XCTAssertEqual(swiftError.toObjC, expectedObjcError)
        }
    }

    func testErrorMessagesPreservedInNSError() {
        let testMessages = [
            "Token is malformed",
            "User denied FinanceKit access",
            "Network request timed out",
            "Cannot read FinanceKit permission status",
            "Unexpected error occurred",
        ]

        let errors: [FinanceKitError] = [
            .invalidToken(message: testMessages[0]),
            .permissionError(message: testMessages[1]),
            .linkApiError(message: testMessages[2]),
            .permissionAccessError(message: testMessages[3]),
            .unknown(
                error: NSError(
                    domain: "test",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: testMessages[4]]
                )
            ),
        ]

        for (index, error) in errors.enumerated() {
            let nsError = error.toNSError
            XCTAssertEqual(nsError.localizedDescription, testMessages[index])
            XCTAssertEqual(nsError.userInfo["message"] as? String, testMessages[index])
        }
    }

    func testNSErrorDomainIsConsistent() {
        let errors: [FinanceKitError] = [
            .invalidToken(message: "test"),
            .permissionError(message: "test"),
            .linkApiError(message: "test"),
            .permissionAccessError(message: "test"),
            .unknown(error: NSError(domain: "test", code: 0)),
        ]

        for error in errors {
            let nsError = error.toNSError
            XCTAssertEqual(nsError.domain, kPLKDefaultErrorDomain)
        }
    }

    func testNSErrorCodesMatchObjCEnumValues() {
        let testCases: [(FinanceKitError, Int)] = [
            (.invalidToken(message: ""), PLKPlaidFinanceKitError.invalidToken.rawValue),
            (.permissionError(message: ""), PLKPlaidFinanceKitError.permissionError.rawValue),
            (.linkApiError(message: ""), PLKPlaidFinanceKitError.linkApiError.rawValue),
            (.permissionAccessError(message: ""), PLKPlaidFinanceKitError.permissionAccessError.rawValue),
            (.noAccounts(message: ""), PLKPlaidFinanceKitError.noAccounts.rawValue),
            (.syncFailed(errorType: "", errorCode: "", message: ""), PLKPlaidFinanceKitError.syncFailed.rawValue),
            (.unknown(error: NSError(domain: "", code: 0)), PLKPlaidFinanceKitError.unknown.rawValue),
        ]

        for (swiftError, expectedCode) in testCases {
            let nsError = swiftError.toNSError
            XCTAssertEqual(nsError.code, expectedCode)
        }
    }
}
#endif  // canImport(FinanceKit) && compiler(>=5.10) && !targetEnvironment(macCatalyst)
