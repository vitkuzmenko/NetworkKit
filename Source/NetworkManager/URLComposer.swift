//
//  NetworkUrlComposer.swift
//  Network Manager
//
//  Created by Vitaliy Kuzmenko on 11/04/2018.
//  Copyright © 2018 Vitaliy Kuzmenko. All rights reserved.
//

import Foundation

extension String {
 
    public var urlEncode: String {
        var set = CharacterSet.alphanumerics
        set.insert(charactersIn: "_.-~")
        return addingPercentEncoding(withAllowedCharacters: set) ?? self
    }
    
    public var urlValue: URL? {
        var URLString = self
        if URLString.hasPrefix("//") {
            URLString = "http:" + URLString
            if let URL = URL(string: URLString) {
                return URL
            }
        } else if let URL = URL(string: URLString) {
            return URL
        }
        return nil
    }
    
}

extension URL {
    
    public func appendingQueryParameters(_ queryParameters: [String: Any]) -> URL {
        var url = self
        url.appendQueryParameters(queryParameters)
        return url
    }
    
    public mutating func appendQueryParameters(_ queryParameters: [String: Any]) {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        
        let flatQueryItems = DictionarySerializer(dict: queryParameters).flatKeyValue()
        
        let queryItems = flatQueryItems.map {
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return }
        
        self = url
    }
    
}

public struct URLComposerConfiguration {
    
    public enum Environment: Int {
        case sandbox, product
    }
    
    public let environment: Environment
    
    public let `protocol`: String
    
    public let host: String
    
    public let apiPath: String
    
    public let defaultApiVersion: String?
    
    init(environment: Environment = .product, `protocol`: String = "https", host: String, apiPath: String, defaultApiVersion: String? = nil) {
        self.environment = environment
        self.protocol = `protocol`
        self.host = host
        self.apiPath = apiPath
        self.defaultApiVersion = defaultApiVersion
    }
    
}

public class URLComposer {
    
    public static let `default` = URLComposer()
    
    private var configurations: [URLComposerConfiguration.Environment: URLComposerConfiguration] = [:]
    
    private var configuration: URLComposerConfiguration!
    
    public func baseUrl() -> URL {
        let string = String(format: "%@://%@", configuration.protocol, configuration.host)
        return URL(string: string)!
    }
    
    public func apiUrl(_ version: String? = nil) -> URL {
        var url = self.baseUrl()
        
        let apiVersion = version ?? configuration.defaultApiVersion
        
        if let apiVersion = apiVersion {
            if !configuration.apiPath.contains("%@") {
                let path = String(format: configuration.apiPath, apiVersion)
                url.appendPathComponent(path)
            } else {
                url.appendPathComponent(configuration.apiPath)
                url.appendPathComponent(apiVersion)
            }
        } else {
            url.appendPathComponent(configuration.apiPath)
        }
        
        return url
    }
    
    public func set(configurations: [URLComposerConfiguration], active environment: URLComposerConfiguration.Environment) {
        for configuration in configurations {
            self.configurations[configuration.environment] = configuration
        }
        set(environment: environment)
    }
    
    public func set(environment: URLComposerConfiguration.Environment) {
        guard let configuration = configurations[environment] else {
            fatalError(NSLocalizedString("You should set configuration before environment", comment: ""))
        }
        self.configuration = configuration
    }
    
}
