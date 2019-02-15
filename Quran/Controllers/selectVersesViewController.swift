//
//  selectVersesViewController.swift
//  Quran
//
//  Created by Ahmed khattab on 1/24/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class selectVersesViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    var suraName: String?
    var suraVersesNumber = 0
    var fromVerse:Int = 1
    var toVerse:Int = 1
    var versesArray = [Int]()
    @IBOutlet weak var suraNameLabel: UILabel!
    @IBOutlet weak var fromPickerView: UIPickerView!
    @IBOutlet weak var toPickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        suraNameLabel.text = suraName
        setPickerViewDelegateAndDataSource(pickerView: fromPickerView)
        setPickerViewDelegateAndDataSource(pickerView: toPickerView)
    }
        
    func setPickerViewDelegateAndDataSource(pickerView: UIPickerView) {
        pickerView.dataSource = self
        pickerView.delegate = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return suraVersesNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(versesArray[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if(pickerView.tag == 0)
        {
            fromVerse = versesArray[row]
            print(fromVerse)
        }
        else
        {
            toVerse = versesArray[row]
            print(toVerse)
        }
    }
    
    fileprivate func raiseAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defualtAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defualtAction)
        present(alertController, animated: true, completion: nil)
    }


    @IBAction func startMemorization(_ sender: Any) {
        print(fromVerse)
        print(toVerse)
        if(fromVerse <= toVerse)
        {
            let searchQuranByVoiceVC = storyboard?.instantiateViewController(withIdentifier: "SearchQuranByVoice") as? SearchQuranByVoiceViewController
            navigationController?.pushViewController(searchQuranByVoiceVC!, animated: true)
            let stringCompare = searchQuranByVoiceVC?.RetrieveVerses(Name: "BigDataSet(small)", Type: "csv", SoraName: suraName!, start: fromVerse, end: toVerse)
            searchQuranByVoiceVC?.retriev = stringCompare!
            
        }
        else
        {
            raiseAlertController(title: "Error", message: "'From' value must be less than or equal to 'To' value")
        }
    }

}

