//
//  CustomTableViewCell.swift
//  TestMyMusic
//
//  Created by Visarg on 08.09.2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var TrekImageView: UIImageView!
    @IBOutlet weak var TrekNameLabel: UILabel!
    @IBOutlet weak var TrekTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func commonInit(_ name: String, _ image: String, _ time: String) {
        TrekImageView.image = UIImage(named: image)
        TrekNameLabel.text = name
        TrekTime.text = time
    }
}

