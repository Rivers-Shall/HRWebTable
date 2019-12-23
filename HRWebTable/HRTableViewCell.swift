//
//  HRTableViewCell.swift
//  HRWebTable
//
//  Created by 肖江 on 2019/12/23.
//  Copyright © 2019 rivers. All rights reserved.
//

import UIKit

class HRTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
