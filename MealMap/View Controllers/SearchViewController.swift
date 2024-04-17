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

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      if !searchBar.text!.isEmpty {
          searchBar.resignFirstResponder()
          
          dataTask?.cancel()
          isLoading = true
          tableView.reloadData()
          
          hasSearched = true
          searchResults = []
          
          let url = edamamURL(searchText: searchBar.text!)
          let session = URLSession.shared
          let dataTask = session.dataTask(with: url){data, response, error in
              if let error = error {
                print("Failure! \(error.localizedDescription)")
              } else if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 {
                if let data = data {
                    self.searchResults = parse(data: data)
                    DispatchQueue.main.async {
                      self.isLoading = false
                      self.tableView.reloadData()
                    }
                  return
                }
              } else {
                print("Failure! \(response!)")
              }
              DispatchQueue.main.async {
                self.hasSearched = false
                self.isLoading = false
                self.tableView.reloadData()
              }
          }
          dataTask.resume()

      }
  }
  func position(for bar: UIBarPositioning) -> UIBarPosition {
      return .topAttached
  }
    
}



// MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate,
UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            if isLoading{
                return 1
            }
            else if !hasSearched {
                return 0
            } else if searchResults.count == 0 {
                return 1
            } else {
                return searchResults.count
            }
     }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if isLoading {
              let cell = tableView.dequeueReusableCell(
                withIdentifier: TableView.CellIdentifiers.loadingCell,
                for: indexPath)

              let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
              spinner.startAnimating()
              return cell
            } else if searchResults.count == 0 {
              return tableView.dequeueReusableCell(
                withIdentifier: TableView.CellIdentifiers.nothingFoundCell,
                for: indexPath)
            } else {
              let cell = tableView.dequeueReusableCell(
                withIdentifier: TableView.CellIdentifiers.searchResultCell,
                for: indexPath) as! SearchResultCell
              let searchResult = searchResults[indexPath.row]
                cell.recipeNameLabel.text = searchResult.name
                cell.calorieLabel.text = searchResult.cal
                
                cell.artworkImageView.layer.cornerRadius = 50
                if let smallURL = URL(string: searchResult.imageLink) {
                    downloadTask = cell.artworkImageView.loadImage(url: smallURL)
                }
              return cell
            }
      }
    
    func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath){
          tableView.deselectRow(at: indexPath, animated: true)
          let recipe = searchResults[indexPath.row]
          performSegue(withIdentifier: "ShowRecipe", sender: recipe)
      }
    
    func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            if searchResults.count == 0 || isLoading {
                return nil
            } else {
                return indexPath
            }
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0;//Choose your custom row height
    }
}


// MARK: - Helper Methods
func edamamURL(searchText: String) -> URL {
    let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    var urlString = "https://api.edamam.com/api/recipes/v2?type=public&q="
    urlString = urlString + encodedText + "&app_id=34fcf9ae&app_key=52660009ab7340e7b0cf21ea3849cb6d"
    let url = URL(string: urlString)
    return url!
}


func parse(data: Data) -> [SearchResult] {
}
