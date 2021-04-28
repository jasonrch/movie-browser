//
//  SearchViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/19/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    private var searchViewModel = ViewModel()
    
    @IBOutlet weak var tableViewActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self

        //Set View Model bindings.
        self.searchViewModel.reloadTableViewCompletion = { [weak self] in
            DispatchQueue.main.async {
                self?.searchResultsTableView.reloadData()
            }
        }
        self.searchViewModel.loadingStatus = { [weak self]  in
            DispatchQueue.main.async {
                let isLoading = self?.searchViewModel.isLoading ?? false
                if isLoading{
                    self?.tableViewActivityIndicator.startAnimating()
                } else{
                    self?.tableViewActivityIndicator.stopAnimating()
                }
            }
        }
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let movieDetailsPage = segue.destination as? MovieDetailViewController, let cell = sender as? MovieTableViewCell {
            
            movieDetailsPage.selectedTitle = cell.searchResults?.originalTitle
            movieDetailsPage.selectedReleaseDate = cell.searchResults?.releaseDate
            movieDetailsPage.selectedOverview = cell.searchResults?.overview
            movieDetailsPage.selectedImage = cell.movieImage
            
        }
    }
}



extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        // Hide Keyboard
        searchBar.resignFirstResponder()
        
        //Call the search movie from the view model based on te search text query
        guard searchBar.text != nil else { return }
        self.searchViewModel.movieSearchBootstrap(query: searchBar.text!)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        
        // Hide Keyboard
        searchBar.resignFirstResponder()
        
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchViewModel.numberOfResultsForCurrentPage
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCellIdentifier", for: indexPath) as! MovieTableViewCell
        let cellSearchResult = self.searchViewModel.getCurrentPageResults(at: indexPath)
        cell.searchResults = cellSearchResult
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedcell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "segueSearchDetailIdentifier", sender: selectedcell)
    }
}
