//
//  ApiProvider.swift
//  
//
//  Created by Роман Анпилов on 13.03.2023.
//

import Foundation

public protocol ApiProvider {
    public func requestPlain<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T
}

public extension ApiProvider {
    @available(macOS 12.0, *)
    public func requestPlain<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async throws -> T {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.parameters.compactMap { (key, value) in
            .init(name: key, value: value)
        }
        
        guard let url = urlComponents.url else {
            Log.error(RequestError.invalidURL)
            throw RequestError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            
            
            guard let response = response as? HTTPURLResponse else {
                throw RequestError.noResponse
            }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    Log.error(RequestError.decode)
                    throw RequestError.decode
                }
                Log.info("Success")
                return decodedResponse
            case 401:
                Log.error(RequestError.unauthorized)
                throw RequestError.unauthorized
            default:
                Log.error(RequestError.unexpectedStatusCode)
                throw RequestError.unexpectedStatusCode
            }
        } catch {
            throw RequestError.unknown
        }
    }
}
