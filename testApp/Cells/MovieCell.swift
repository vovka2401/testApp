//
//  MovieCell.swift
//  testApp
//
//  Created by Volodymyr Khvaliuk on 31.08.2022.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var year: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
