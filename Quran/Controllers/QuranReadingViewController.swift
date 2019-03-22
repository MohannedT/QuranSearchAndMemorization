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
    var suraName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let uthmanFont = UIFont(name: "UthmanTN1Ver10", size: UIFont.labelFontSize) else {
//            fatalError("Faild to load font")
//        }
//        SuraVersesTextView.font = UIFontMetrics.default.scaledFont(for: uthmanFont)
//        SuraVersesTextView.adjustsFontForContentSizeCategory = true
        
        SuraVersesTextView.text = selectedVerses
        suraNameLabel.text = suraName
    }




}
