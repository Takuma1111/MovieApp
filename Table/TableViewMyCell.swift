//
//  TableViewCell.swift
//  MovieApp
//
//  Created by 村上拓麻 on 2019/03/01.
//  Copyright © 2019 村上拓麻. All rights reserved.
//

import UIKit

class TableViewMyCell: UITableViewCell {


    
    @IBOutlet var label: UITextView!
    
    @IBOutlet var imageMovie: UIImageView!
    @IBOutlet var popularity: UIImageView!
    
    @IBOutlet weak var textViewWidthConstraint: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.isEditable = false    //textFieldを編集不可にする
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

