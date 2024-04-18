//
//  IngredientCell.swift
//  MealMap
//
//  Created by Jabir Chowdhury
//

import UIKit

class IngredientCell: UITableViewCell {
    @IBOutlet weak var ingredientLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
