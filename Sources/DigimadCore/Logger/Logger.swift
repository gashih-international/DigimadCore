//
//  Logger.swift
//  
//
//  Created by Роман Анпилов on 13.03.2023.
//

import Foundation

fileprivate extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
        return dateFormatter.string(from: self)
    }
}

enum LogEvent: String {
    case error = "[‼️]"
    case info = "[ℹ️]"
    case debug = "[💬]"
    case warning = "[⚠️]"
}

func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}

public final class Log {
    private static var isLoggingEnabled: Bool {
        return true
    }
    
    /// Logs error messages on console with prefix [‼️]
    class func error( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.error.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    /// Logs info messages on console with prefix [ℹ️]
    class func info ( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.info.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    /// Logs debug messages on console with prefix [💬]
    class func debug( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.debug.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }

    /// Logs warnings verbosely on console with prefix [⚠️]
    class func warning( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.warning.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}
