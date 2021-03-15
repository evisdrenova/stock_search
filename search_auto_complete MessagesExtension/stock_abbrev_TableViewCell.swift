//
//  stock_abbrev_TableViewCell.swift
//  search_auto_complete MessagesExtension
//
//  Created by Evis Drenova on 2/17/21.
//

import UIKit

class stock_abbrev_TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var stock_name: UITextField! //the left most label with the name
    @IBOutlet weak var stock_abbrev: UITextField! // the right most label with the abbrev

   @IBOutlet weak var daily_change: UITextField! //daily change text label
    
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
