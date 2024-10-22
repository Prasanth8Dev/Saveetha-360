//
//  LeaveDatailTableViewCell.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 22/10/24.
//

import UIKit

class LeaveDatailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var leaveTypeLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var leaveDurationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
