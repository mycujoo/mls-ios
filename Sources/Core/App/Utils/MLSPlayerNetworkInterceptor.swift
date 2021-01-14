//
// Copyright © 2020 mycujoo. All rights reserved.
//

import Foundation

protocol MLSPlayerNetworkInterceptorDelegate: class {
    func received(response: String, forRequestURL: URL?)
}

class MLSPlayerNetworkInterceptor: URLProtocol {
    /// Unfortunately, AVPlayer does not invoke any custom URLProtocol out of the box
    /// (https://stackoverflow.com/questions/52148903/custom-urlprotocol-cannot-work-with-avplayer)
    ///
    /// However, for non-http(s) protocols, this class does seem to get invoked. Therefore, it is recommended to use this method to map the URL to a non-https protocol
    /// temporarily. This URLProtocol will internally rewrite it back to` https://` before actually making the request.
    /// - seeAlso: https://developer.apple.com/forums/thread/128989
    static func prepare(_ assetURL: URL) -> URL {
        return URL(string: assetURL.absoluteString.replacingFirstOccurrence(of: "https://", with: "none://"))!
    }

    /// Undo the `prepare()` work.
    static func unprepare(_ assetURL: URL) -> URL {
        return URL(string: assetURL.absoluteString.replacingFirstOccurrence(of: "none://", with: "https://"))!
    }

    private static var hasRegisteredInterceptor = false

    static weak var delegate: MLSPlayerNetworkInterceptorDelegate? = nil

    /// Call this method to register this URLProtocol so that it will intercept `m3u8` traffic. It is safe to call it multiple times.
    /// - delegate: A class-level delegate that will be notified of any intercepted HLS traffic.
    static func register(withDelegate delegate: MLSPlayerNetworkInterceptorDelegate) {
        self.delegate = delegate
        guard !hasRegisteredInterceptor else { return }
            hasRegisteredInterceptor = true
            URLProtocol.registerClass(MLSPlayerNetworkInterceptor.self)
    }

    struct Constants {
        static let RequestHandledKey = "URLProtocolRequestHandled"
    }

    var session: URLSession?
    var sessionTask: URLSessionDataTask?

    override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)

        if session == nil {
            session = URLSession(configuration: .`default`, delegate: self, delegateQueue: nil)
        }
    }

    override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: Constants.RequestHandledKey, in: request) != nil {
            return false
        }
        return request.url?.pathExtension == "m3u8" || request.url?.pathExtension == "ts"
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        guard let url = request.url else { return request }

        return URLRequest(url: unprepare(url))
    }

    override func startLoading() {
        let newRequest = ((request as NSURLRequest).mutableCopy() as? NSMutableURLRequest)!
        MLSPlayerNetworkInterceptor.setProperty(true, forKey: Constants.RequestHandledKey, in: newRequest)

        sessionTask = session?.dataTask(with: newRequest as URLRequest) { [weak self] (data, response, error) in
            guard let self = self else { return }
            guard let data = data, let response = response else {
                self.client?.urlProtocol(self, didFailWithError: error ?? NSError(domain: "MLSPlayerURLProtocol", code: -1, userInfo: nil))
                return
            }

            MLSPlayerNetworkInterceptor.delegate?.received(response: String(decoding: data, as: UTF8.self), forRequestURL: self.request.url)

            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)

            self.session?.finishTasksAndInvalidate()
        }

        sessionTask?.resume()
    }

    override func stopLoading() {
        sessionTask?.cancel()
        session?.invalidateAndCancel()
    }

    deinit {
        session?.invalidateAndCancel()
    }
}


extension MLSPlayerNetworkInterceptor: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let policy = URLCache.StoragePolicy(rawValue: request.cachePolicy.rawValue) ?? .notAllowed
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: policy)
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
        completionHandler(request)
    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        guard let error = error else { return }
        client?.urlProtocol(self, didFailWithError: error)
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let protectionSpace = challenge.protectionSpace
        let sender = challenge.sender

        if protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = protectionSpace.serverTrust {
                let credential = URLCredential(trust: serverTrust)
                sender?.use(credential, for: challenge)
                completionHandler(.useCredential, credential)
                return
            }
        }
    }

    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        client?.urlProtocolDidFinishLoading(self)
    }
}
