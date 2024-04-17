//
//  CreateRecipeViewController.swift
//  MealMap
//
//  Created by Jabir Chowdhury on 5/18/23.
//
// Link for help with sending a post URL session request
// stackoverflow.com/questions/31937686/how-to-make-http-post-request-with-json-body-in-swift
//

import UIKit
import CoreData

class CreateRecipeViewController: UIViewController{
    var dateValue: Date!
    var managedObjectContext: NSManagedObjectContext!
    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var recipeImageLink: UITextField!
    @IBOutlet weak var recipeIngredients: UITextView!
    @IBOutlet weak var validate: UIButton!
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var calLabel: UILabel!
    var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeIngredients!.layer.borderWidth = 1
        recipeIngredients!.layer.borderColor = UIColor.systemGray5.cgColor
        
        save.isEnabled = false
        
        let swipeRight = UISwipeGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard))
        swipeRight.direction = .down
        view.addGestureRecognizer(swipeRight)
    }
    
    
    @IBAction func saveTapped(_ button: UIBarButtonItem){
        guard let mainView = navigationController?.parent?.view
          else { return }
        let hudView = HudView.hud(inView: mainView, animated: true)
          hudView.text = "Saved"
        
        let meal = Meal(context: managedObjectContext)
        
        meal.name = recipeName.text
        meal.cal = calLabel.text
        meal.imageLink = recipeImageLink.text
        meal.date = dateValue
        
        let ingredientStrings = recipeIngredients.text.generalSplit().joined(separator: "#")
        
        meal.ingredientList = ingredientStrings
        
        do {
            try managedObjectContext.save()
            afterDelay(0.6) {
              hudView.hide()
              self.navigationController?.popViewController(
                animated: true)
            }
        } catch { // 4
            let alert = UIAlertController(
                title: "",
                message: "Save Unsuccessful",
                preferredStyle: .alert)
              let action = UIAlertAction(
                title: "Close",
                style: .default,
                handler: nil)
              alert.addAction(action)
              self.present(alert, animated: true, completion: nil)
            fatalError("Error: \(error)")
          }
    }
    
    @IBAction func buttonTapped(_ button: UIButton){
        
        if(recipeName.text == "" || recipeImageLink.text == "" || recipeIngredients.text == ""){
            let alert = UIAlertController(
                title: "",
                message: "Please fill in all fields",
                preferredStyle: .alert)
              let action = UIAlertAction(
                title: "Close",
                style: .default,
                handler: nil)
              alert.addAction(action)
              present(alert, animated: true, completion: nil)
        }
        else{
            let ingredients = recipeIngredients.text.generalSplit()
            print(ingredients)
            
            struct DataModel: Codable {
                let ingr: [String]
            }
            
            let postData = DataModel(ingr: ingredients)
            let jsonData = try? JSONEncoder().encode(postData)
            
            print(jsonData as Any)
                
            let url = nutritionURL()
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
            request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
            request.httpBody = jsonData
        
            let dataTask = session.dataTask(with: request){data, response, error in
                if let error = error {
                    print("Failure! \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "",
                            message: "Something Went wrong",
                            preferredStyle: .alert)
                          let action = UIAlertAction(
                            title: "Close",
                            style: .default,
                            handler: nil)
                          alert.addAction(action)
                          self.present(alert, animated: true, completion: nil)
                    }
                } else if let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 {
                    if let data = data {
//                        self.searchResults = parse(data: data)
                        DispatchQueue.main.async {
                            self.calLabel.text =  parseNutritionData(data: data) + " calories"
                            self.validate.isEnabled = false
                            self.recipeIngredients.isEditable = false
                            self.recipeName.isEnabled = false
                            self.recipeImageLink.isEnabled = false
                            self.save.isEnabled = true
                        }
                        return
                    }
                } else if let httpResponse = response as? HTTPURLResponse,
                         httpResponse.statusCode == 555 || httpResponse.statusCode == 422 {
                    print("Failure! \(response!)")

                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "",
                            message: "Recipe with insufficient quality to process correctly",
                            preferredStyle: .alert)
                          let action = UIAlertAction(
                            title: "Close",
                            style: .default,
                            handler: nil)
                          alert.addAction(action)
                          self.present(alert, animated: true, completion: nil)
                    }
                   
                } else {
                    print("Failure! \(response!)")

                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "",
                            message: "Something went wrong",
                            preferredStyle: .alert)
                          let action = UIAlertAction(
                            title: "Close",
                            style: .default,
                            handler: nil)
                          alert.addAction(action)
                          self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    @objc func hideKeyboard(
      _ gestureRecognizer: UIGestureRecognizer
    ){
        view.endEditing(true)
    }
    
}

// MARK: - Helper Methods
func nutritionURL() -> URL {
    let urlString = "https://api.edamam.com/api/nutrition-details?app_id=9d0af5c5&app_key=d62410613663efbc8843802b250d44bc"
    let url = URL(string: urlString)
    return url!
}

func parseNutritionData(data: Data) -> String {
    do {
        let decoder = JSONDecoder()
        let result = try decoder.decode(
            NutritionResultArray.self, from: data)
        return String(Int(result.calories))
    } catch {
        print("JSON Error: \(error)")
        return "0"
    }
}

