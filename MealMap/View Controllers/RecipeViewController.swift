//
//  ViewController.swift
//  MealMap
//
//  Created by Jabir Chowdhury on 5/10/23.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController{
    
    var recipe: SearchResult!
    var downloadTask: URLSessionDownloadTask?
    
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var ingredientCount: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recipeImageView.transform = self.recipeImageView.transform.rotated(by: .pi / 1.5)
        performAnimation()
        
        
        let cellNib = UINib(nibName: "IngredientCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
                            "IngredientCell")
        
        recipeNameLabel.text = recipe.name
        calorieLabel.text = recipe.cal
        recipeImageView.layer.cornerRadius = 50
        if let smallURL = URL(string: recipe.imageLink) {
            downloadTask = recipeImageView.loadImage(url: smallURL)
        }
        
        ingredientCount.text = String(recipe.ingredientList.count) + " Ingredients"
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(
      for segue: UIStoryboardSegue,
      sender: Any?
    ){
    if segue.identifier == "AddMeal" {
        let controller = segue.destination as! DatePickerViewController
        controller.recipe = sender as? SearchResult
        controller.managedObjectContext = managedObjectContext
      }
    }
    
    @IBAction func add() {
        let recipe_copy = recipe
        performSegue(withIdentifier: "AddMeal", sender: recipe_copy)
    }
    
    func performAnimation(){
        UIView.animate(withDuration: 0.5) { [self] in
            self.recipeImageView.transform = self.recipeImageView.transform.rotated(by: .pi / -1.5)
        }
    }
    
    
}



// MARK: - Table View Delegate
extension RecipeViewController: UITableViewDelegate,
                                UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return recipe.ingredientList.count
     }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(
              withIdentifier: "IngredientCell",
              for: indexPath) as! IngredientCell

            let ingredientLine = recipe.ingredientList[indexPath.row]
            cell.ingredientLabel.text = ingredientLine
            return cell
        }
    
    func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath){
          tableView.deselectRow(at: indexPath, animated: true)
      }
}

