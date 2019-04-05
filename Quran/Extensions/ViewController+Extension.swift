//
//  ViewController+Extension.swift
//  Quran
//
//  Created by Eyad Shokry on 3/31/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlertController(withTitle: String, withMessage: String, action: (() -> Void)? = nil) {
        performUIUpdatesOnMain {
            let alertController = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in
                action?()
            }))
            self.present(alertController, animated: true)
        }
    }
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
