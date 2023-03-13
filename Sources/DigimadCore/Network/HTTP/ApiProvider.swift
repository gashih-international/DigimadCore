//
//  ApiProvider.swift
//  
//
//  Created by Роман Анпилов on 13.03.2023.
//

import Foundation
import Combine

public struct Response<T> {
    public let value: T
    public let response: URLResponse
}

public protocol ApiProvider {
    @available(macOS 12.0, *)
    func requestPlain<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) -> AnyPublisher<Response<T>, Error>
}

public extension ApiProvider {
    @available(macOS 12.0, *)
    func requestPlain<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) -> AnyPublisher<Response<T>, Error> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.parameters.compactMap { (key, value) in
            .init(name: key, value: value)
        }
        
        guard let url = urlComponents.url else {
            Log.error(RequestError.invalidURL)
            return Fail(error: RequestError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try JSONDecoder().decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
