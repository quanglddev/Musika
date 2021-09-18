//
//  ViewController.swift
//  Musika
//
//  Created by QUANG on 6/22/17.
//  Copyright © 2017 Superior Future. All rights reserved.
//

import UIKit
import MediaPlayer
import ChameleonFramework

let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height

let cellID = "MusicCell"

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    @IBOutlet weak var musicsTableView: UITableView!
    @IBOutlet weak var imageAva: UIImageView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var someView: UIView!
    @IBOutlet weak var logoView: UIView!
    
    @IBOutlet weak var nextLogoView: UIView!
    @IBOutlet weak var background: UIImageView!

    //MARK: Properties
    var songs = [MusicModel]()
    let player = MPMusicPlayerController.systemMusicPlayer()
    
    var musicSourcePicker: MediaSourcePicker!
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var playingIndex = -1
    var previousPlayingIndex = -1
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .pickerChanged, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        logoView.backgroundColor = GradientColor(.radial, frame: logoView.frame, colors: [RandomFlatColor(), UIColor.red])
        nextLogoView.backgroundColor = GradientColor(.topToBottom, frame: nextLogoView.frame, colors: [RandomFlatColor(), UIColor(red:0.06, green:0.07, blue:0.09, alpha:1.0)])
        background.backgroundColor = GradientColor(.radial, frame: background.frame, colors: [RandomFlatColor(), RandomFlatColor(), RandomFlatColor(), RandomFlatColor(), UIColor(red:0.06, green:0.07, blue:0.09, alpha:1.0)])
        musicsTableView.backgroundColor = background.backgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customWidth = picker.frame.width
        customHeight = someView.frame.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(pickerChanged), name: .pickerChanged, object: nil)
        
        //Set up picker
        musicSourcePicker = MediaSourcePicker()
        
        picker.delegate = musicSourcePicker
        picker.dataSource = musicSourcePicker
        
        DispatchQueue.main.async {
            self.musicsTableView.separatorColor = .black
            self.musicsTableView.rowHeight = CGFloat(screenHeight / 8)
            self.imageAva.layer.borderColor = UIColor.black.cgColor
            self.imageAva.layer.borderWidth = 2.0
            self.imageAva.layer.cornerRadius = 3.0
            self.imageAva.clipsToBounds = true
        }
        
        //TODO: Set cell height = 1/8 screen height
        //TODO: play button boader = 1
        //TODO: ava boader = 1
        //TODO: fly in cell
        //TODO: running title
        //TODO: center face album
        
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                if let mediaItems = MPMediaQuery.songs().items {
                    self.songs = [MusicModel]()
                    
                    for mediaItem in mediaItems {
                        let artwork = mediaItem.artwork?.image(at: CGSize(width: screenWidth / 3, height: screenWidth / 3))
                        let title = mediaItem.title
                        let artist = mediaItem.artist
                        let length = mediaItem.playbackDuration
                        if length.isZero || length.isNaN || length.isInfinite {
                            continue
                        }
                        print(length)
                        let lyric = mediaItem.lyrics
                        let newSong = MusicModel(artwork: artwork, song: mediaItem, title: title ?? "NO NAME", artist: artist ?? "UNKNOWN", length: length , lyric: lyric ?? "")
                        self.songs.append(newSong)
                    }
                }
                
                DispatchQueue.main.async {
                    self.musicsTableView.reloadData()
                }
            }
        }
    }
    
    func pickerChanged() {
        let source = picker.selectedRow(inComponent: 0)
        //Change source here
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = musicsTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MusicCell
        
        let selectedSong = songs[indexPath.row]
        cell.imageAlbum.image = selectedSong.artwork
        cell.lblArtist.text = selectedSong.artist?.uppercased()
        cell.lblTitle.text = selectedSong.title
        cell.lblLength.text = stringFromTimeInterval(interval: selectedSong.length ?? 0)
        
        if player.playbackState == .playing {
            if indexPath.row == playingIndex {
                cell.btnPlayOutlet.tintColor = UIColor.red
            }
            else {
                cell.btnPlayOutlet.tintColor = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if player.playbackState != .playing || playingIndex != indexPath.row {
            let selectedSong = songs[indexPath.row]
            player.setQueue(with: MPMediaItemCollection(items: [selectedSong.song!]))
            player.play()
            
            previousPlayingIndex = playingIndex
            if songs[safe: previousPlayingIndex] != nil {

                let cell = self.musicsTableView.cellForRow(at: IndexPath(row: previousPlayingIndex, section: indexPath.section)) as! MusicCell
                cell.btnPlayOutlet.tintColor = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0)
            }
            
            playingIndex = indexPath.row
            
            //TODO: Change the previous button
            
            let cell = musicsTableView.cellForRow(at: indexPath) as! MusicCell
            cell.btnPlayOutlet.tintColor = UIColor.red
        }
        else {
            player.pause()
            
            let cell = musicsTableView.cellForRow(at: indexPath) as! MusicCell
            cell.btnPlayOutlet.tintColor = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0)
        }
        
        musicsTableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        
        UIView.animate(withDuration: 0.2, animations: {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        })
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let time = Int(interval)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        
        return String(format: "%0.2d.%0.2d",minutes,seconds)
    }
}

