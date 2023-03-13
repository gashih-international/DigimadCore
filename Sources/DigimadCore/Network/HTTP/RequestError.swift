//
//  RequestError.swift
//  
//
//  Created by Роман Анпилов on 13.03.2023.
//

import Foundation

public enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
}
