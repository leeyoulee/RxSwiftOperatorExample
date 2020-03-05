//
//  OperatorTableViewCell.swift
//  rxSwiftOperator
//
//  Created by 이유리 on 28/11/2019.
//  Copyright © 2019 이유리. All rights reserved.
//

import UIKit

class OperatorTableViewCell: UITableViewCell {
    static let identifier = String(describing: OperatorTableViewCell.self)
    
    @IBOutlet weak var operatorTitle: UILabel!
    
    var segue: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
