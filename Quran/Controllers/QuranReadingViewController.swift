//
//  QuranReadingViewController.swift
//  Quran
//
//  Created by Eyad Shokry on 3/20/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import Speech

class QuranReadingViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var suraNameLabel: UILabel!
    @IBOutlet weak var chapterNumberLabel: UILabel!
    @IBOutlet weak var SuraVersesTextView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ar-SA"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var selectedVerses = ""
    var selectedVersesWithoutTashkel = ""
    var from = 0
    var to = 0
    var suraName = ""
    var ChapterID: String?
    var userSayingArray: [String] = []
    var tempArray : [String] = []
    var retriev = ""
    var versesplus = ""
    var ArrayA : [String] = []
    var ArrayB : [String] = []
    var arr : [String] = []
    var finalResult : String = ""

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let uthmanFont = UIFont(name: "UthmanTN1Ver10", size: UIFont.labelFontSize) else {
//            fatalError("Faild to load font")
//        }
//        SuraVersesTextView.font = UIFontMetrics.default.scaledFont(for: uthmanFont)
//        SuraVersesTextView.adjustsFontForContentSizeCategory = true
        SuraVersesTextView.text = selectedVerses
        suraNameLabel.text = suraName
        chapterNumberLabel.text = " الجزء (\(ChapterID!))"
        
        
        microphoneButton.isEnabled = false
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
            case .notDetermined:
                isButtonEnabled = false
                print("not authorized yet")
            case .denied:
                isButtonEnabled = false
                print("user denied access to speech recognition")
            case .restricted:
                isButtonEnabled = false
                print("speech recognition is restricted on this device")
            }
            
            OperationQueue.main.addOperation {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }

        
    }


    @IBAction func onClickStartRecitationButton(_ sender: UIButton) {
        performUIUpdatesOnMain {
            self.SuraVersesTextView.text = nil
        }
        
        retriev = GetVerses(SoraName: suraName, start: from, end: to, flag: 0)
        print(retriev)
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setImage(UIImage(named: "Record.png"), for: .normal)
            let correctUserWords = self.longestCommonSubsequence(self.userSayingArray, sec: self.selectedVersesWithoutTashkel.components(separatedBy: " "))
            print("----------this user what he said :----------- \n", self.userSayingArray)

            print("----------THIS IS THE CORRECT WORDS WHICH THE USER SAID :-----------")
            print(correctUserWords)
            for _ in 0..<self.userSayingArray.count{
                
                self.userSayingArray.remove(at: 0)
                
            }
            for _ in 0..<self.tempArray.count{
                
                self.tempArray.remove(at: 0)
                
            }

            print("----------this user what he after delete :----------- \n", self.userSayingArray ,"\n nothing ?! " )
            print("----------this tempArray  after delete :----------- \n", self.tempArray ,"\n nothing ?! " )


        } else {
            startRecording()
            microphoneButton.setImage(UIImage(named: "Stop.png"), for: .normal)
        }
    }
    
    
    func startRecording(){
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        }
        catch {
            print("audioSession properties weren't set because of an error")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: {(result, error) in
            var isFinal = false
            if result != nil {
                self.SuraVersesTextView.text = result?.bestTranscription.formattedString
                self.tempArray = (result?.bestTranscription.formattedString.components(separatedBy: " "))!
                for _ in 0..<self.tempArray.count-1{
                    
                    self.tempArray.remove(at: 0)
                    
                }
                self.userSayingArray.append(self.tempArray[0])
               // self.userSayingArray = ["بسم", "الل", "الرحمن", "الرحمة"]
                
             
                
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine Couldn't start because of an error")
        }
        
        SuraVersesTextView.text = "Start Recitating.."
    }

    

}



extension QuranReadingViewController {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        }
        else {
            microphoneButton.isEnabled = false
        }
    }
}
