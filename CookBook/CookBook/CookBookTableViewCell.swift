//
//  CookBookTableViewCell.swift
//  CookBook
//
//  Created by Meera Iyer on 4/16/22.
//

import UIKit


class CookBookTableViewCell: UITableViewCell {
    @IBOutlet weak var tableRecipe: UILabel!
    @IBOutlet weak var tableCalories: UILabel!
    @IBOutlet weak var tableTime: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
