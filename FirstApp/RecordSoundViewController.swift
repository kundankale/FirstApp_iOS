//
//  RecordSoundViewController.swift
//  FirstApp
//
//  Created by Shweta Kale on 04/08/18.
//  Copyright © 2018 Kundan. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController , AVAudioRecorderDelegate{

    var audioRecorder : AVAudioRecorder!
    
    @IBOutlet weak var stoprecButton: UIButton!
    @IBOutlet weak var recButton: UIButton!
    @IBOutlet weak var recordinglable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        stoprecButton.isEnabled = false
    }
   
    @IBAction func record(_ sender: Any) {
        
        configureUI(recordState: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        
        
        
        configureUI(recordState: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
       
        if(flag){
        performSegue(withIdentifier: "stopRecordingSegue", sender: recorder.url)
        }else{
            print("Recording was not successfull")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="stopRecordingSegue"){
            
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioUrl = sender as! URL
            playSoundVC.recordedAudioUrl = recordedAudioUrl
            
        }
    }
    

    func configureUI(recordState: Bool){
        if recordState{
            
            recordinglable.text = "Recoding in progress"
            stoprecButton.isEnabled = true
            recButton.isEnabled = false
            
        }else{
            recordinglable.text = "Tap to Record"
            stoprecButton.isEnabled = false
            recButton.isEnabled = true
        }
    }
    
    
}

