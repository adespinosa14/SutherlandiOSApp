//
//  EventCellTableViewCell.swift
//  iOSApp
//
//  Created by Andrew Espinosa on 11/24/24.
//

import UIKit

class EventCellTableViewCell: UITableViewCell {

    @IBOutlet weak var eventIdLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
