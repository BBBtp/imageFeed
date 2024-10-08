//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 30.09.2024.
//

import Foundation
import UIKit

class AlertPresenter {
    
    static let shared = AlertPresenter()
    private init () {}
    
    func show(vc: UIViewController, model: AlertModel){
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        
        let actionFirst = UIAlertAction(title: model.firstButtonText, style: .default) {
            _ in model.completion()
        }
        
        alert.addAction(actionFirst)
        
        if let secondButtonText = model.secondButtonText, let secondCompletion = model.secondCompletion {
            let actionSecond = UIAlertAction(title: secondButtonText, style: .default){
                _ in secondCompletion()
            }
            alert.addAction(actionSecond)
        }
        alert.view.accessibilityIdentifier = "Alert"
        vc.present(alert, animated: true)
    }
}
