//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Eric Typaldos on 3/10/15.
//  Copyright (c) 2015 Eric Typaldos. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    /* Audio Recorder setup */
    var audioRecorder:AVAudioRecorder!
    // Init our custom RecordedAudio class
    var recordedAudio:RecordedAudio!
    // Set directory path
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String;
    // Set up formatter
    let formatter = NSDateFormatter();


    
    //--------------------------------

    override func viewWillAppear(animated: Bool) {
        // Hide stop button
        stopButton.hidden = true;
    }

    
    @IBAction func recordAudio(sender: UIButton) {
        // Show stop button
        stopButton.hidden = false;
        // Change label
        recordingInProgress.text = "Stop Recording";
        // Disable recordButton
        recordButton.enabled = false;
        
        // TODO: Record users voice
        // Formatter - need to move this into init or something? TODO XXX
        formatter.dateFormat = "ddMMyyyy-HHmmss";
        // Set current dateTime, format it and use it to set name of recording
        var currentDateTime = NSDate();
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav";
        // Set up path array
        var pathArray = [self.dirPath, recordingName];
        var filePath = NSURL.fileURLWithPathComponents(pathArray);
        // Set up AVAudio session
        var session = AVAudioSession.sharedInstance();
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil);
        // Initialize and prepare recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil);
        // Set this vc as delegate for audioRecorder
        audioRecorder.delegate = self;
        // Enable metering, prep recording file, record
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord();
        audioRecorder.record();
        
        
    }
    
    // We get this fn because we set this vc to the delegate for our audioRecorder
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
        // Save recorded audio
        recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!);

        // Perform segue :) - here we specify the identifier (set in storyboard) and the recordedAudio obj
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio);
        } else {
            println("Recording was not successful");
            recordButton.enabled = true;
            stopButton.hidden = true;
        }
    }
    
    // This is us
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Gets called just before segue is performed
        if (segue.identifier == "stopRecording") {
            // Set vc constant as our segue's destination view controller(as keyword specifies the type)
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController;
            
            let data = sender as RecordedAudio;
            playSoundsVC.receivedAudio = data;
        }
    }

    @IBAction func stopAudio(sender: UIButton) {
        // Hide stop btn
        stopButton.hidden = true;
        // Set text on label
        recordingInProgress.text = "Tap to Begin Recording";
        // Enable record btn        
        recordButton.enabled = true;
        
        // Stop recorder and deactivate session
        audioRecorder.stop();
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil);
    }
}

