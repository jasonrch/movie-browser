//
//  ViewModel.swift
//  MovieBrowser
//
//  Created by Julio Reyes on 4/28/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation
import UIKit

typealias completion = () -> ()
class ViewModel: NSObject {
    // Declare and initialize variables
    private var apiClient: Network = Network()
    
    var lastQuery: String?
    
    var page = 1
    private var searchResultModel: Movies? = nil
    {
        didSet {
            self.reloadTableViewCompletion?()
        }
    }
    
    // Check if the API Service is making a network call
    var isLoading: Bool = false {
        didSet{
            self.loadingStatus?()
        }
    }
    
    var reloadTableViewCompletion: (completion)?
    var loadingStatus: (completion)?
    
    override init() {
        self.lastQuery = ""
    }
    
    func movieSearchBootstrap(query: String) {
        getSearchResultsForMovies(query: query)
    }
    
    private func getSearchResultsForMovies(query: String){
       // guard searchResultsList!.totalPages >= page else { return }
        self.isLoading = true
        try! self.apiClient.downloadSearchResultsForMovies(searchQuery: query, forPage: page, complete: { (MovieSearchResults, error) in
            self.searchResultModel = MovieSearchResults
            self.isLoading = false
        })
    }
}

extension ViewModel {
    var currentPage: Int {
        return searchResultModel?.page ?? 1
    }
    
    var totalPages: Int {
        return searchResultModel?.totalPages ?? 0
    }
    
    var numberOfResultsForCurrentPage: Int{
        return searchResultModel?.results.count ?? 0
    }
    
    var totalResults: Int{
        return searchResultModel?.totalResults ?? 0
    }
    
    func getCurrentPageResults(at indexPath: IndexPath) -> Result{
        return searchResultModel!.results[indexPath.row]
    }
}


