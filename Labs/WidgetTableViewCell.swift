//
//  WidgetTableViewCell.swift
//  Labs
//
//  Created by Dzmitry Mukhliada on 12/25/18.
//  Copyright © 2018 Dzmitry Mukhliada. All rights reserved.
//

import UIKit

class WidgetTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var nextDate: UILabel!
    @IBOutlet weak var labs: UILabel!
    @IBOutlet weak var dateProgress: UIProgressView!
    @IBOutlet weak var labsProgress: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
