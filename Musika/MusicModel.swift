//
//  MusicModel.swift
//  Musika
//
//  Created by QUANG on 6/22/17.
//  Copyright © 2017 Superior Future. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicModel: NSObject {
    var artwork: UIImage?
    var song: MPMediaItem?
    var title: String?
    var artist: String?
    var length: Double?
    var lyric: String?
    
    init(artwork: UIImage?, song: MPMediaItem?, title: String, artist: String, length: Double, lyric: String) {
        
        guard song != nil else {
            return
        }
        
        guard artwork != nil else {
            return
        }
        
        guard length != nil else {
            return
        }
        
        self.artwork = artwork
        self.song = song
        self.title = title
        self.artist = artist
        self.length = length
        self.lyric = lyric
    }
}
