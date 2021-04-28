//
//  Movies.swift
//  MovieBrowser
//
//  Created by Julio Reyes on 4/28/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation


// MARK: - MovieSearchResults Base

typealias MovieList = [Movies]
struct Movies: Codable {
    let page, totalResults, totalPages: Int
    let results: [Result]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct Result: Codable {
    let voteCount, id: Int?
    let video: Bool?
    let voteAverage: Double?
    let title: String?
    let popularity: Double?
    let posterPath: String?
    let originalLanguage: String?
    let originalTitle: String
    let genreIDS: [Int]?
    let backdropPath: String?
    let adult: Bool?
    let overview, releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id, video
        case voteAverage = "vote_average"
        case title, popularity
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case backdropPath = "backdrop_path"
        case adult, overview
        case releaseDate = "release_date"
    }
}

