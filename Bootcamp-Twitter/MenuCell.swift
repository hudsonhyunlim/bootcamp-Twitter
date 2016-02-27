//
//  MenuCell.swift
//  Bootcamp-Twitter
//
//  Created by Hyun Lim on 2/25/16.
//  Copyright © 2016 Lyft. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var menuConf: [String:String]? {
        didSet {
            if let menuConf = self.menuConf {
                if let name = menuConf["name"] as String? {
                    self.nameLabel.text = name
                }
                if let imageName = menuConf["imageName"] as String? {
                    self.iconImageView.image = UIImage(named: imageName)
                }
            }
        }
    }

}
