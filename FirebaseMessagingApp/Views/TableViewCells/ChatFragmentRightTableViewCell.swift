//
//  ChatFragmentRightTableViewCell.swift
//  FirebaseMessagingApp
//
//  Created by Ankit Chaudhary on 24/05/20.
//  Copyright © 2020 webdevlopia. All rights reserved.
//

import UIKit

class ChatFragmentRightTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundContainer: UIView!
    @IBOutlet weak var fragmentContainer: UIView!
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var otherDetailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
