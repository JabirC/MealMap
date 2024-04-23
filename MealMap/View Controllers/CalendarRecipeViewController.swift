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
    
   
  }

