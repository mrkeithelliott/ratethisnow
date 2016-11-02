//
//  RatedItemCell.swift
//  ratethisnow
//
//  Created by Keith Elliott on 10/17/16.
//  Copyright © 2016 GittieLabs. All rights reserved.
//

import UIKit
import Messages

class RatedItemCell: UICollectionViewCell {
    static let reuseId = "stickerCell"
    var ratedItem: RTNItem?
    
    @IBOutlet weak var stickerView: MSStickerView!
    
}

class AddRatedItemCell: UICollectionViewCell {
    static let reuseId = "add_ratings_cell"
    
    @IBOutlet weak var imageView: UIImageView!
}
