//
//  SubjectTableViewCell.swift
//  LabsComplete
//
//  Created by Dzmitry Mukhliada on 12/18/18.
//  Copyright © 2018 Dzmitry Mukhliada. All rights reserved.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subjectTitle: UILabel!
    @IBOutlet weak var nextLabDate: UILabel!
    @IBOutlet weak var labsProgress: UIProgressView!
    @IBOutlet weak var dateProgress: UIProgressView!
    @IBOutlet weak var labsPassCounter: UIStepper!
    @IBOutlet weak var secondStack: UIStackView!
    @IBOutlet weak var thirdStack: UIStackView!
    @IBOutlet weak var labsLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func labsPassedCounter(_ sender: Any) {
    }
}
