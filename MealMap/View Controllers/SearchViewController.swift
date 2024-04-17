//
//  SearchViewController.swift
//  MealMap
//
//  Created by Jabir Chowdhury on 5/10/23.
//

import UIKit
import CoreData


class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var searchResults = [SearchResult]()
    var hasSearched = false
    var isLoading = false
    var dataTask: URLSessionDataTask?
    var downloadTask: URLSessionDownloadTask?
    
    var managedObjectContext: NSManagedObjectContext!
    
    struct TableView {
      struct CellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
      }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 55, left: 0, bottom:
        0, right: 0)
        var cellNib = UINib(nibName: "SearchResultCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
                            TableView.CellIdentifiers.searchResultCell)
        
        
        cellNib = UINib(
          nibName: TableView.CellIdentifiers.nothingFoundCell,
          bundle: nil)
        tableView.register(
          cellNib,
          forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(
          nibName: TableView.CellIdentifiers.loadingCell,
          bundle: nil)
        tableView.register(
          cellNib,
          forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(
      for segue: UIStoryboardSegue,
      sender: Any?
    ){
    if segue.identifier == "ShowRecipe" {
        let controller = segue.destination as! RecipeViewController
        controller.recipe = sender as? SearchResult
        controller.managedObjectContext = managedObjectContext
      }
    }

}

