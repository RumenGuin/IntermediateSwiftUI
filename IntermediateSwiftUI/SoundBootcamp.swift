//
//  SoundBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 30/12/21.
//

import SwiftUI
import AVKit //Audio Video Kit

class SoundManager{
    static let instance = SoundManager() //singleton
    
    var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case tada
        case badum
    }
    
    func playSound(sound: SoundOption) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3")
        else {return }
        
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error{
            print("Error playing sound \(error.localizedDescription)")
        }
    }
}

struct SoundBootcamp: View {
    
    var body: some View {
        VStack(spacing: 40){
            Button("Play Sound 1") {
                SoundManager.instance.playSound(sound: .tada)
            }
            
            Button("Play Sound 2") {
                SoundManager.instance.playSound(sound: .badum)
            }
        }
    }
}

struct SoundBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        SoundBootcamp()
    }
}
