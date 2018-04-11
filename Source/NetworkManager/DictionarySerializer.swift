//
//  DictionarySerializer.swift
//  Locals
//
//  Created by Vitaliy Kuzmenko on 02/08/16.
//  Copyright © 2016 Locals. All rights reserved.
//

import Foundation

open class DictionarySerializer {
    
    var dict: [String: Any]
    
    public init(dict: [String: Any]) {
        self.dict = dict
    }
    
    open func getParametersInFormEncodedString() -> String {
        return serialize(dict: dict)
    }
    
    open func serialize(dict: [String: Any], nested: String? = nil) -> String {
        
        var strings: [String] = []
        
        for (key, value) in dict {
            
            var string = key
            
            if let nested = nested {
                string = String(format: "%@[%@]", nested, key)
            }
            
            string = serialize(value: value, withString: string, nested: nested)
            strings.append(string)
        }
        
        return strings.joined(separator: "&")
    }
    
    open func serialize(array: [Any], nested: String? = nil) -> String {
        
        var strings: [String] = []
        
        for value in array {
            var string = ""
            
            if let nested = nested {
                string = String(format: "%@[]", nested)
            }
            
            string = serialize(value: value, withString: string, nested: nested)
            strings.append(string)
        }
        
        return strings.joined(separator: "&")
    }
    
    open func serialize(value: Any, withString string: String, nested: String? = nil) -> String {
        var string = string
        
        if let value = value as? String {
            string = String(format: "%@=%@", string, value.urlEncode)
        } else if let value = value as? NSNumber {
            string = String(format: "%@=%@", string, value.stringValue.urlEncode)
        } else if let value = value as? [String: Any] {
            string = serialize(dict: value, nested: string)
        } else if let value = value as? [Any] {
            string = serialize(array: value, nested: string)
        }
        
        return string
    }
    
    open func flatKeyValue() -> [String: String] {
        let string = serialize(dict: dict)
        let components = string.components(separatedBy: "&")
        var keyValues: [String: String] = [:]
        for item in components {
            let components = item.components(separatedBy: "=")
            if components.count != 2 { continue }
            keyValues[components[0]] = components[1]
        }
        return keyValues
    }
    
}
