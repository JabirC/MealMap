//
//  CalendarViewController.swift
//  MealMap
//
//  Created by Jabir Chowdhury on 5/10/23.
//

// UICalendarview setup inspired by ohmyswift.com/blog/2022/06/12/implementing-a-custom-native-calendar-using-uicalendarview-in-ios16-and-swift/

import UIKit
import CoreData

class CalendarViewController: UIViewController, NSFetchedResultsControllerDelegate{
    var managedObjectContext: NSManagedObjectContext!
    var dateList = [Date]()
    let calendarView = UICalendarView()
    lazy var fetchedResultsController: NSFetchedResultsController<Meal> = {
      let fetchRequest = NSFetchRequest<Meal>()

      let entity = Meal.entity()
      fetchRequest.entity = entity

      let sort = NSSortDescriptor(key: "date", ascending: true)
      fetchRequest.sortDescriptors = [sort]
        
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
        
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        NSLayoutConstraint.activate([

             calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
             calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
             calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
             calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        calendarView.tintColor = .systemOrange
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        
        calendarView.delegate = self
        // Do any additional setup after loading the view.
        
        
        fetchedResultsController.fetchedObjects!.forEach { Meal in
            dateList.append(Meal.date!)
        }
    }
    
    deinit {
      fetchedResultsController.delegate = nil
    }
    
    // MARK: - Navigation
    override func prepare(
      for segue: UIStoryboardSegue,
      sender: Any?
    ){
    if segue.identifier == "ShowDay" {
        let controller = segue.destination as! CalendarRecipeViewController
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


}
