//
//  BufferTimeTableViewCell.swift
//  SIMATS 360
//
//  Created by Admin - iMAC on 07/10/24.
//

import UIKit

class BufferTimeTableViewCell: UITableViewCell {
    @IBOutlet weak var currentMonthlabel: UILabel!
    @IBOutlet weak var lateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
