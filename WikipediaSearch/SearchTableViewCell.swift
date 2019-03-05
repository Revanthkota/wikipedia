//
//  SearchTableViewCell.swift
//  WikipediaSearch
//
//  Created by venkat on 26/08/18.
//  Copyright © 2018 freelancer. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var titlename: UILabel!
    @IBOutlet weak var descriptlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
