//
//  AudioController.swift
//  BlackJack
//
//  Created by kpugame on 2021/05/31.
//

import AVFoundation

let SoundBackground = "background.mp3"
let SoundButton = "button.mp3"
let SoundPaging = "paging.wav"

let AudioEffectFiles = [SoundBackground, SoundButton, SoundPaging]

class AudioController {
    private var audio = [String: AVAudioPlayer]()
    
    var player:AVAudioPlayer?
    
    func preloadAudioEffects(audioFileNames: [String]){
        for effect in AudioEffectFiles{
            let soundPath = Bundle.main.path(forResource: effect, ofType: nil)
            let soundURL = NSURL.fileURL(withPath: soundPath!)
            
            do{
                player = try AVAudioPlayer(contentsOf: soundURL)
                guard let player = player else{
                    return
                }
                
                player.numberOfLoops = 0
                player.prepareToPlay()
                
                audio[effect] = player
            }catch let error{
                print(error.localizedDescription)
            }
        }
    }
    
    func playerEffect(name: String, repeating: Bool = false){
        if let player = audio[name]{
            if player.isPlaying {
                player.currentTime = 0
            }else {
                if repeating {
                    player.numberOfLoops = -1
                    player.play()
                }
                else{
                    player.play()
                }
            }
        }
    }
}
