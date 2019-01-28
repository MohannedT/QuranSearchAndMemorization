//
//  SearchQuranByVoiceViewController.swift
//  Quran
//
//  Created by Eyad Shokry on 10/19/18.
//  Copyright © 2018 Eyad Shokry. All rights reserved.
//

import UIKit
import Speech
import Foundation


class SearchQuranByVoiceViewController: UIViewController, SFSpeechRecognizerDelegate {
    var retriev = ""
    var versesplus = ""
    var ArrayA : [String] = []
    var ArrayB : [String] = []
    var arr : [String] = []
    var finalResult : String = ""
    @IBOutlet weak var recognizedText: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ar-SA"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do žny additional setup after loading the view.
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
        
        // new
        
        let verses = retriev
        print(verses)
        self.ArrayA  = verses.components(separatedBy: " ")
        print(ArrayA)
        
        /*var ArrayB = versesplus.components(separatedBy: " ")
            print(ArrayB)
 
       
        var arr : [String] = []
        
        for i in 0..<ArrayB.count{
            
            if (ArrayA [i] != ArrayB [i]) {
                arr.append(ArrayB[i])
                
            }
        }
        print(arr)
        // end of new
*/
        
    }
    
    

    @IBAction func microphoneTapped(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setImage(UIImage(named: "Record.png"), for: .normal)
            print("-----------this is the final result----------------- \n " , self.finalResult)

            
          
            
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
                self.recognizedText.text = result?.bestTranscription.formattedString
                self.versesplus = (result?.bestTranscription.formattedString)!
                self.ArrayB = self.versesplus.components(separatedBy: " ")
                for l in 0..<self.ArrayB.count-1{
                  
                    self.ArrayB.remove(at: 0)
                }
          
                /* ---------new------- */
                for i in 0..<1{
                    if(self.ArrayA.count>0){
                    if (self.ArrayA [i] != self.ArrayB [i]) {
                        self.arr.append(self.ArrayB[i])
                    self.ArrayA.remove(at: 0)
                     self.ArrayB.remove(at: 0)
                        /*change the color here to red color*/
                        self.finalResult = self.finalResult + self.arr[0] + " "
                       self.arr.remove(at: 0)
                    }
                    else {
                        /*change the color here to green color*/

                        self.finalResult = self.finalResult + self.ArrayB[0] + " "
                       self.ArrayA.remove(at: 0)
                       self.ArrayB.remove(at: 0)
                    }
                    }
                    else {
                        break
                    }
                }
        

             
                /* -------- end of new ------- */
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
        
        recognizedText.text = "Say something, I'm listening!"
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        }
        else {
            microphoneButton.isEnabled = false
        }
    }
    
    
    //..............................new.............................
    func readDataFromCSV(fileName:String, fileType: String)-> String!
    {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    func cleanRows(file:String)->String
    {
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
        return cleanFile
    }
    func csv(data: String) -> [[String]]
    {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
   
    func GetSoraID(SoraName: String) -> Int
    {
        var data = readDataFromCSV(fileName: "newcsv" , fileType: "csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        var SoraID = 0
        for index in 1...114
        {
            if(csvRows[index][1] == SoraName)
            {
                SoraID = Int(csvRows[index][0])!
                break
            }
        }
        return SoraID
    }

    
    func RetrieveVerses(Name: String ,Type: String , SoraName: String, start: Int , end: Int) -> String
    {
        var data = readDataFromCSV(fileName: Name, fileType: Type)
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        var EntireVerses = ""
        let SoraID = GetSoraID(SoraName: SoraName)
        for index in 1...6236
        {
            if(Int(csvRows[index][1]) == SoraID)
            {
                if(Int(csvRows[index][2])! == start || Int(csvRows[index][2])! > start && Int(csvRows[index][2])! < end || Int(csvRows[index][2])! == end)
                {
                    EntireVerses = EntireVerses + csvRows[index][3] + " "
                }
                if(Int(csvRows[index][2])! == end)
                {
                    break
                }
            }
        }
        return EntireVerses
    }

  

}


