//
//  SoundManager.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-12.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var player: AVAudioPlayer?

    func play(fileName: String) {
        let soundUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(fileName, ofType: "caf")!)
        do {
            self.player = try AVAudioPlayer(contentsOfURL: soundUrl)
            self.player?.prepareToPlay()
        } catch {
            print(error)
        }
        self.player?.play()
    }
    
    func stop() {
        self.player?.stop()
    }
}