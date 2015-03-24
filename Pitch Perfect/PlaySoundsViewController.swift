//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Eric Typaldos on 3/10/15.
//  Copyright (c) 2015 Eric Typaldos. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide stop button
        stopButton.hidden = true
        
        // Instantiate audioEngine
        audioEngine = AVAudioEngine();
        // Set
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil);
        
        // Use the receivedAudio filePathUrl property
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil);
        audioPlayer.enableRate = true;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioAtRate(0.5);
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioAtRate(2);
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(2000);
    }
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000);
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        stopButton.hidden = false
        
        audioPlayer.stop();
        audioEngine.stop();
        audioEngine.reset();
        
        // Instantiate AVAudioPlayerNode and attach the node to our global engine
        var audioPlayerNode = AVAudioPlayerNode();
        audioEngine.attachNode(audioPlayerNode);
        
        //Now use the AVAudioUnitTimePitch class
        var changePitchEffect = AVAudioUnitTimePitch();
        changePitchEffect.pitch = pitch;
        audioEngine.attachNode(changePitchEffect);
        
        // Connect both nodes and play
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil);
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil);

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil);
        
        audioPlayerNode.play();
    }
    
    func playAudioAtRate(audioRate: Float) {
        stopButton.hidden = false
        
        audioEngine.stop();
        audioEngine.reset();
        audioPlayer.stop();
        audioPlayer.rate = audioRate;
        audioPlayer.play();
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop();
        stopButton.hidden = true
    }
    

}
