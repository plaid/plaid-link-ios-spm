import Foundation
import LinkKit
import LinkKitObjCInternal

// MARK: FinanceKit

#if canImport(FinanceKit) && compiler(>=5.10) && !targetEnvironment(macCatalyst)
@available(iOS 17.4, *)
@objc public final class PLKPlaidFinanceKit: NSObject {

    /// Objective-C compatible version of SyncBehavior.
    /// Note: Objective-C enums must inherit from Int.
    @objc(PLKSyncBehavior)
    public enum PLKSyncBehavior: Int {

        /// Performs a real sync using live FinanceKit data.
        case live

        /// Simulates sync behavior for testing or local development.
        case simulated

        /// Internal helper to convert back to the modern Swift-only enum if needed.
        internal var swiftValue: PlaidFinanceKit.SyncBehavior {
            switch self {
            case .live: return .live
            case .simulated: return .simulated
            }
        }
    }

    @objc public static func syncFinanceKit(
        token: String,
        requestAuthorizationIfNeeded: Bool,
        syncBehavior: PLKSyncBehavior,
        onSuccess: @escaping () -> Void,
        onError: @escaping (NSError) -> Void
    ) {
        PlaidFinanceKit.sync(
            token: token,
            requestAuthorizationIfNeeded: requestAuthorizationIfNeeded,
            syncBehavior: syncBehavior.swiftValue,
            completion: { result in
                switch result {
                case .success:
                    onSuccess()
                case .failure(let error):
                    onError(error.toNSError)
                }
            }
        )
    }

    /// What `+[PLKPlaidFinanceKit statusWithCompletion:]` reports: whether a FinanceKit sync can run on this
    /// phone, and what the user has decided about sharing Wallet data with your app. Reading it never prompts.
    @objc(PLKFinanceKitStatus)
    public enum PLKFinanceKitStatus: Int {
        /// FinanceKit cannot provide financial data on this device, region or OS version. A sync would fail with
        /// PLKPlaidFinanceKitErrorDataUnavailable, so do not offer Apple Card here.
        case unavailable
        /// The user has never been asked. A sync with requestAuthorizationIfNeeded:YES shows Apple's prompt;
        /// with NO it fails with PLKPlaidFinanceKitErrorPermissionNotRequested.
        case notDetermined
        /// The user declined Apple's prompt, or turned sharing off later. iOS will not prompt again; only the user
        /// can change it, under Settings > Apps > (your app) > Wallet. A sync fails with
        /// PLKPlaidFinanceKitErrorPermissionAccessError.
        case denied
        /// Your app may read the user's Wallet data. An Apple Card in the Wallet, or any account shared with your
        /// app, is not guaranteed, so a sync can still end with PLKPlaidFinanceKitErrorNoAccounts.
        case authorized
        /// FinanceKit did not report a status. Treat it like NotDetermined and let the sync decide.
        case unknown
    }

    /// Reports whether a FinanceKit sync can run on this phone, without prompting the user.
    ///
    /// Use it to decide whether to show an Apple Card option at all (PLKFinanceKitStatusUnavailable),
    /// whether to pass requestAuthorizationIfNeeded:YES to the sync (PLKFinanceKitStatusNotDetermined), or
    /// to send the user to Settings instead of syncing (PLKFinanceKitStatusDenied).
    ///
    /// - Parameter completion: Called with the current status, not necessarily on the main queue.
    /// - Warning: Needs the same FinanceKit entitlement as the sync; without it FinanceKit terminates the
    ///   process. With the entitlement it is safe to call on any device running iOS 17.4 or later,
    ///   including an iPad running your app in compatibility mode.
    /// - Note: Available on iOS 17.4 and later.
    @objc public static func status(completion: @escaping (PLKFinanceKitStatus) -> Void) {
        PlaidFinanceKit.status { completion($0.toObjC) }
    }
}

@available(iOS 17.4, *)
extension PlaidFinanceKit.Status {
    var toObjC: PLKPlaidFinanceKit.PLKFinanceKitStatus {
        switch self {
        case .unavailable: return .unavailable
        case .notDetermined: return .notDetermined
        case .denied: return .denied
        case .authorized: return .authorized
        case .unknown: return .unknown
        @unknown default: return .unknown
        }
    }
}

@available(iOS 17.4, *)
extension FinanceKitError {
    var toObjC: PLKPlaidFinanceKitError {
        switch self {
        case .invalidToken:
            return .invalidToken
        case .permissionError:
            return .permissionError
        case .linkApiError:
            return .linkApiError
        case .permissionAccessError:
            return .permissionAccessError
        case .permissionNotRequested:
            return .permissionNotRequested
        case .dataUnavailable:
            return .dataUnavailable
        case .noAccounts:
            return .noAccounts
        case .syncFailed:
            return .syncFailed
        case .channelClosed:
            return .channelClosed
        case .syncTimedOut:
            return .syncTimedOut
        case .unknown:
            return .unknown
        @unknown default:
            return .unknown
        }
    }

    var toNSError: NSError {
        switch self {
        case .invalidToken(let message), .permissionError(let message),
            .linkApiError(let message), .permissionAccessError(let message), .dataUnavailable(let message),
            .noAccounts(let message), .permissionNotRequested(let message), .channelClosed(let message),
            .syncTimedOut(let message):
            return NSError(
                domain: kPLKDefaultErrorDomain,
                code: self.toObjC.rawValue,
                userInfo: ["message": message, NSLocalizedDescriptionKey: message]
            )
        case .syncFailed(let errorType, let errorCode, let message):
            return NSError(
                domain: kPLKDefaultErrorDomain,
                code: self.toObjC.rawValue,
                userInfo: [
                    "message": message, NSLocalizedDescriptionKey: message,
                    kPLKFinanceKitErrorTypeKey: errorType, kPLKFinanceKitErrorCodeKey: errorCode,
                ]
            )
        case .unknown(let error):
            return NSError(
                domain: kPLKDefaultErrorDomain,
                code: self.toObjC.rawValue,
                userInfo: [
                    "message": error.localizedDescription, NSLocalizedDescriptionKey: error.localizedDescription,
                ]
            )
        @unknown default:
            return NSError(
                domain: kPLKDefaultErrorDomain,
                code: self.toObjC.rawValue,
                userInfo: [
                    "message": "unknown default", NSLocalizedDescriptionKey: "unknown default",
                ]
            )
        }
    }
}
#endif  // if canImport(FinanceKit) && compiler(>=5.10) && !targetEnvironment(macCatalyst)
