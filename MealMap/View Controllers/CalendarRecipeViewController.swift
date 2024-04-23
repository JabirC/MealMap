//
//  CalendarRecipeViewController.swift
//  MealMap
//
//  Created by Jabir Chowdhury on 5/17/23.
//

import UIKit
import CoreData

class CalendarRecipeViewController: UIViewController{
    var dateValue: Date!
    var managedObjectContext: NSManagedObjectContext!
    var downloadTask: URLSessionDownloadTask?
    var changed = false
    
    @IBOutlet weak var dayDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Meal> = {
      let fetchRequest = NSFetchRequest<Meal>()

      let entity = Meal.entity()
      fetchRequest.entity = entity

      let sort = NSSortDescriptor(key: "date", ascending: true)
      fetchRequest.sortDescriptors = [sort]
        
        let predicate = NSPredicate(format: "date >= %@ && date < %@",Calendar.current.startOfDay(for: dateValue) as CVarArg, Calendar.current.startOfDay(for: dateValue + 86400) as CVarArg  )
      fetchRequest.predicate = predicate
        
      fetchRequest.fetchBatchSize = 20

      let fetchedResultsController = NSFetchedResultsController(
        fetchRequest: fetchRequest,
        managedObjectContext: self.managedObjectContext,
        sectionNameKeyPath: nil,
        cacheName: nil)

      fetchedResultsController.delegate = self
      return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch()
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY"
        let dateString = dateFormatter.string(from: dateValue)
        dayDate.text = dateString
        
        
        
        
        
        var cellNib = UINib(nibName: "SearchResultCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
                            "SearchResultCell")
        
        
        cellNib = UINib(
          nibName: "NothingSavedCell",
          bundle: nil)
        tableView.register(
          cellNib,
          forCellReuseIdentifier: "NothingSavedCell")
    }
    
    // MARK: - Navigation
    override func prepare(
      for segue: UIStoryboardSegue,
      sender: Any?
    ){
    if segue.identifier == "ShowCalendarRecipe" {
        let controller = segue.destination as! RecipeViewController
        controller.recipe = sender as? SearchResult
        controller.managedObjectContext = managedObjectContext
      }
    if segue.identifier == "CreateRecipe" {
            let controller = segue.destination as! CreateRecipeViewController
            controller.dateValue = sender as? Date
            controller.managedObjectContext = managedObjectContext
        }
    }
    
    // MARK: - Helper methods
    func performFetch() {
      do {
        try fetchedResultsController.performFetch()
      } catch {
        fatalCoreDataError(error)
      }
    }
    
    @IBAction func create() {
        performSegue(withIdentifier: "CreateRecipe", sender: dateValue)
    }
}

// MARK: - Table View Delegate
extension CalendarRecipeViewController: UITableViewDelegate,
                                        UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            if fetchedResultsController.sections![0].numberOfObjects == 0{
                return 1
            }
            else {
                return fetchedResultsController.sections![0].numberOfObjects
            }
        }
    
   
  }

