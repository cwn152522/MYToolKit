//
//  QiuShiBaiKeCellTableViewCell.swift
//  Demo
//
//  Created by cwn on 2018/11/29.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class QiuShiBaiKeCellTableViewCell: UITableViewCell {
    @IBOutlet weak var headerImage: UIImageView!//头像
    @IBOutlet weak var name: UILabel!//昵称
    @IBOutlet weak var content: UILabel!//内容文字
    @IBOutlet weak var thumb: UIImageView!//内容附图
    @IBOutlet weak var thumbHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
