//
//  ProcedureCell.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 1/20/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class ProcedureCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var radiograph: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var angle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initialization Code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //Configure the view for the selected state
    }
}
