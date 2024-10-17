//
//  SalaryReportTableViewCell.swift
//  SIMATS 360
//
//  Created by Admin - iMAC on 03/10/24.
//

import UIKit

class SalaryReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
