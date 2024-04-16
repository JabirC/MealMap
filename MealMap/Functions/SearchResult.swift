//
//  SearchResult.swift
//  MealMap
//
//  Created by Jabir Chowdhury on 5/10/23.
//

import UIKit
import Foundation

class ResultArray: Decodable {
    var count = 0
    var from = 0
    var to = 0
    var hits = [SearchResult]()
}
class SearchResult: Codable {
    var recipe: Recipe
    
    struct Recipe: Codable{
        var label: String
        var calories: Float
        var yield: Int
        var image: String
        var ingredientLines: [String]
        
        init(){
            label = ""
            calories = 0.0
            yield = 0
            image = ""
            ingredientLines = []
        }
    }
    
    var name: String{
        return recipe.label
    }
    
    var cal: String{
        return String(Int(recipe.calories/(Float(recipe.yield)))) + " calories"
    }
    
    var imageLink: String {
        return recipe.image
    }
    
    var ingredientList: [String]{
        return recipe.ingredientLines
    }
    
    // MARK: - Helper Method
    init (meal: Meal) {
        self.recipe = Recipe()
        recipe.label = meal.name!
        recipe.calories = Float(meal.cal!.components(separatedBy: " ")[0]) ?? 0.0
        recipe.image = meal.imageLink!
        recipe.yield = 1
        recipe.ingredientLines = meal.ingredientList?.split() ?? []
    }
    
}
