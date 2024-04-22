//
//  DatePickerViewController.swift
//  MealMap
//
//  Created by Jabir Chowdhury on 5/17/23.
//

// Received help from link: nemecek.be/blog/161/how-to-use-uicalendarview-in-ios#basic-setup
// with setting up UICalendarView

import UIKit
import CoreData

class DatePickerViewController: UIViewController {

    var recipe: SearchResult!
    var dateSelected: Date!
    var managedObjectContext: NSManagedObjectContext!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBarButton.isEnabled = false
        let calendarView = UICalendarView()
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        calendarView.tintColor = .systemMint
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        print(recipe.name)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func done() {
        guard let mainView = navigationController?.parent?.view
          else { return }
        let hudView = HudView.hud(inView: mainView, animated: true)
          hudView.text = "Added"
        
        let meal = Meal(context: managedObjectContext)
        
        meal.name = recipe.name
        meal.cal = recipe.cal
        meal.imageLink = recipe.imageLink
        meal.date = dateSelected
        
        let ingredientStrings = recipe.ingredientList.joined(separator: "#")
        
        meal.ingredientList = ingredientStrings
        
        do {
            try managedObjectContext.save()
            afterDelay(0.6) {
              hudView.hide()
              self.navigationController?.popViewController(
                animated: true)
            }
        } catch { // 4
            fatalError("Error: \(error)")
          }
    }

}


