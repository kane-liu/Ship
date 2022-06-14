import APIKit
import Foundation

open class Session {
    public let session: APIKit.Session
    private let dependency: Dependency

    public init(dependency: Dependency, sessionConfiguration: URLSessionConfiguration = .default) {
        self.dependency = dependency
        sessionConfiguration.timeoutIntervalForRequest = 15
        sessionConfiguration.timeoutIntervalForResource = 60
        let adapter = URLSessionAdapter(configuration: sessionConfiguration)
        session = APIKit.Session(adapter: adapter, callbackQueue: .sessionQueue)
    }

    @discardableResult
    open func send<R: Request>(_ request: R, callbackQueue: CallbackQueue? = nil, progressHandler: @escaping (Int64, Int64, Int64) -> Void, completionHandler: @escaping (Result<R.Response, SessionTaskError>) -> Void) -> SessionTask? {
        let proxy = RequestProxy(request: request, dependency: dependency)
        return session.send(proxy, callbackQueue: callbackQueue, progressHandler: progressHandler, completionHandler: completionHandler)
    }
}
