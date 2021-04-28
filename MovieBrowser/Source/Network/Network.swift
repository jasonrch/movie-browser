//
//  Network.swift
//  SampleApp
//
//  Created by Struzinski, Mark - Mark on 9/17/20.
//  Copyright © 2020 Lowe's Home Improvement. All rights reserved.
//

import Foundation
typealias MovieDataRetrievalComplete = (_ results:Movies?, Error?) -> ()

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}


enum Environment{
    case dev
    case test
    case prod
    
    func baseURL() -> String {
        return "\(urlAppProtocol())://\(urlIMDBDomain())/\(urlRoute())"
    }
    
    func baseURLforImage() -> String {
        return "\(urlAppProtocol())://\(urlIMDBImageDomain())"
    }
    
    func urlAppProtocol() -> String{
        switch self {
        case .prod:
            return "https"
        default:
            return "http"
        }
    }
    
    func urlIMDBDomain() -> String{

            return "api.themoviedb.org"

    }
    
    func urlIMDBImageDomain() -> String{

            return "image.tmdb.org/t/p"
    }
    
    func urlRoute() -> String{
        return "3"
    }
}

let enviroment: Environment = .prod

let baseURL = enviroment.baseURL()
let baseImageURL = enviroment.baseURLforImage()

var baseSearchURL: String {
    return "\(baseURL)/search"
}
var movieSearch: String {
    return "\(baseSearchURL)/movie"
}

var imageURLforCompactSize: (String) -> String = { urlString in
    return "\(baseImageURL)/w600_and_h900_bestv2\(String(urlString))"
}



struct Network {

    let apiKey = "5885c445eab51c7004916b9c0313e2d3"
    
    func downloadSearchResultsForMovies(searchQuery: String, forPage: Int, complete:  @escaping MovieDataRetrievalComplete) throws -> Void {
        
        var urlComponents = URLComponents(string: movieSearch)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: "2a61185ef6a27f400fd92820ad9e8537"),
                           URLQueryItem(name: "query", value: searchQuery),
                           URLQueryItem(name: "page", value: String(forPage))]
        
        let fullURL: URL = urlComponents!.url!
        
        var searchRequest = URLRequest(url: fullURL,
                                       cachePolicy: .useProtocolCachePolicy,
                                       timeoutInterval: 10.0)
        searchRequest.httpMethod = "GET"
        
        print(urlComponents?.string ?? "None")
        
        let task = URLSession.shared.dataTask(with: searchRequest, completionHandler: { (data: Data?,
            response: URLResponse?, error: Error?) in
            guard let _ = response as? HTTPURLResponse, let data = data else {
                print("API response error")
                complete(nil, error?.localizedDescription as? Error)
                return
            }
            
            // Parse the data
            let searchResults = try! newJSONDecoder().decode(Movies.self, from: data)
            complete (searchResults, error?.localizedDescription as? Error)
            
        })
        
        task.resume()
    }
}
