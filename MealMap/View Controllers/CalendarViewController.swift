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
    
}
