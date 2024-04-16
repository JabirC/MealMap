//
//  SearchResultCell.swift
//  MealMap
//
//  Created by Jabir Chowdhury on 5/10/23.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
