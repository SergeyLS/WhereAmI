//
//  RecordsTableViewCell.swift
//  WhereAmI
//
//  Created by Sergey Leskov on 2/8/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
