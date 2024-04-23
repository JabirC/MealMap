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
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if fetchedResultsController.sections![0].numberOfObjects  == 0 && !changed  {
              return tableView.dequeueReusableCell(
                withIdentifier: "NothingSavedCell",
                for: indexPath)
            } else {
              let cell = tableView.dequeueReusableCell(
                withIdentifier: "SearchResultCell",
                for: indexPath) as! SearchResultCell
                
                let meal = fetchedResultsController.object(at: indexPath)
                cell.recipeNameLabel.text = meal.name
                cell.calorieLabel.text = meal.cal
                cell.artworkImageView.layer.cornerRadius = 50
                
                
                if let smallURL = URL(string: meal.imageLink!) {
                    downloadTask = cell.artworkImageView.loadImage(url: smallURL)
                    print(downloadTask as Any)
                }
                
                return cell
            }
        }
    
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath){
            tableView.deselectRow(at: indexPath, animated: true)
            let meal = fetchedResultsController.object(at: indexPath)
            let recipe = SearchResult(meal: meal)
            performSegue(withIdentifier: "ShowCalendarRecipe", sender: recipe)
        }
    
    func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            if fetchedResultsController.sections![0].numberOfObjects == 0 {
                return nil
            } else {
                return indexPath
            }
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if fetchedResultsController.sections![0].numberOfObjects == 0{
            return 300.0
        }
        return 140.0;//Choose your custom row height
    }
}



// MARK: - NSFetchedResultsController Delegate Extension
extension CalendarRecipeViewController:
    NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(
        _ controller:
    NSFetchedResultsController<NSFetchRequestResult> ){
        print("*** controllerWillChangeContent")
        tableView.beginUpdates()
      }
      func controller(
        _ controller:
    NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ){
    switch type { case .insert:
          print("*** NSFetchedResultsChangeInsert (object)")
        if(fetchedResultsController.sections![0].numberOfObjects == 1){
            changed = true
            tableView.reloadData()
        }
        else{
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
        case .delete:
          print("*** NSFetchedResultsChangeDelete (object)")
          tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
          print("*** NSFetchedResultsChangeUpdate (object)")
          if let cell = tableView.cellForRow(
            at: indexPath!) as? SearchResultCell {
            let meal = controller.object(
              at: indexPath!) as! Meal
              
              cell.recipeNameLabel.text = meal.name
              cell.calorieLabel.text = meal.cal
              
              cell.artworkImageView.layer.cornerRadius = 50
              if let smallURL = URL(string: meal.imageLink!) {
                  downloadTask = cell.artworkImageView.loadImage(url: smallURL)
              }
    }
        case .move:
          print("*** NSFetchedResultsChangeMove (object)")
          tableView.deleteRows(at: [indexPath!], with: .fade)
          tableView.insertRows(at: [newIndexPath!], with: .fade)
        @unknown default:
          print("*** NSFetchedResults unknown type")
        }
    }
      func controller(
        _ controller:
    NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ){
    switch type { case .insert:   print("*** NSFetchedResultsChangeInsert (section)")
        tableView.insertSections(
          IndexSet(integer: sectionIndex), with: .fade)
      case .delete:
        print("*** NSFetchedResultsChangeDelete (section)")
        tableView.deleteSections(
          IndexSet(integer: sectionIndex), with: .fade)
      case .update:
        print("*** NSFetchedResultsChangeUpdate (section)")
      case .move:
        print("*** NSFetchedResultsChangeMove (section)")
      @unknown default:
        print("*** NSFetchedResults unknown type")
      }
  }
    func controllerDidChangeContent(
      _ controller:
  NSFetchedResultsController<NSFetchRequestResult> ){
      print("*** controllerDidChangeContent")
      tableView.endUpdates()
    }
  }

