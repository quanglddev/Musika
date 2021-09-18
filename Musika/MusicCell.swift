//
//  MusicCell.swift
//  Musika
//
//  Created by QUANG on 6/22/17.
//  Copyright © 2017 Superior Future. All rights reserved.
//

import UIKit
import MarqueeLabel

class MusicCell: UITableViewCell {
    
    @IBOutlet weak var imageAlbum: UIImageView!
    @IBOutlet weak var btnPlayOutlet: UIButton!
    
    @IBOutlet weak var lblTitle: MarqueeLabel!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblLength: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.btnPlayOutlet.layer.borderColor = UIColor.black.cgColor
        self.btnPlayOutlet.layer.borderWidth = 1.0
        self.btnPlayOutlet.clipsToBounds = true
        
        self.imageAlbum.layer.borderColor = UIColor.black.cgColor
        self.imageAlbum.layer.borderWidth = 1.0
        self.imageAlbum.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
