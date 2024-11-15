//
//  SwapStatusTableViewCell.swift
//  Saveetha 360
//
//  Created by Admin - iMAC on 15/11/24.
//

import UIKit

class SwapStatusTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dutyDateLabel: UILabel!
    @IBOutlet weak var dutyStatusLabel: UILabel!
    @IBOutlet weak var dutyStatusImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
