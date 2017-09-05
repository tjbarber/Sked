//
//  AlertHelper.swift
//  Sked
//
//  Created by TJ Barber on 9/5/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

class AlertHelper {
    static func showAlert(withTitle title: String, withMessage message: String, presentingViewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        presentingViewController.present(alertController, animated: true, completion: nil)
    }
}