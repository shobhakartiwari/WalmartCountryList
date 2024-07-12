//
//  Extensions.swift
//  WalmartCountryList
//
//  Created by Shobhakar on 7/11/24.
//
import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true,completion: nil)
    }
}
