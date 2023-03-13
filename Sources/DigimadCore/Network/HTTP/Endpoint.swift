//
//  Endpoint.swift
//  
//
//  Created by Роман Анпилов on 13.03.2023.
//

import Foundation

public protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var headers: [String:String] { get }
    var parameters: [String: String] { get }
    var body: [String:Any]? { get }
}

public extension Endpoint {
    var parameters: [String: String] {
        [:]
    }
    
    var body: [String:Any]? {
        nil
    }
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "127.0.0.1:5000"
    }
}
