//
//  QuranReadingViewController.swift
//  Quran
//
//  Created by Eyad Shokry on 3/20/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class QuranReadingViewController: UIViewController {

    @IBOutlet weak var suraNameLabel: UILabel!
    @IBOutlet weak var chapterNumberLabel: UILabel!
    @IBOutlet weak var SuraVersesTextView: UITextView!
    var selectedVerses = ""
    var selectedVersesWithoutTashkel = ""
    var from = 0
    var to = 0
    var suraName = ""
    var ChapterID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let uthmanFont = UIFont(name: "UthmanTN1Ver10", size: UIFont.labelFontSize) else {
//            fatalError("Faild to load font")
//        }
//        SuraVersesTextView.font = UIFontMetrics.default.scaledFont(for: uthmanFont)
//        SuraVersesTextView.adjustsFontForContentSizeCategory = true
        print(from)
        print(to)
        SuraVersesTextView.text = selectedVerses
        suraNameLabel.text = suraName
        chapterNumberLabel.text = " الجزء (\(ChapterID!))"
    }


    @IBAction func onClickStartRecitationButton(_ sender: UIButton) {
        let recitationVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchQuranByVoice") as? SearchQuranByVoiceViewController
        recitationVC?.retriev = recitationVC?.GetVerses(SoraName: suraName, start: from, end: to, flag: 0) ?? ""
        self.navigationController?.pushViewController(recitationVC!, animated: true)
    }
    

}
