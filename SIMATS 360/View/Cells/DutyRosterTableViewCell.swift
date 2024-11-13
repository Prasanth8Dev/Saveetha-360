//
//  DutyRosterTableViewCell.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 13/11/24.
//

import UIKit

class DutyRosterTableViewCell: UITableViewCell {
    @IBOutlet weak var dutyRosterImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dutyTimeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dutyScheduleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
