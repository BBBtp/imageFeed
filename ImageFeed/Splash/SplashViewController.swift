//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 15.08.2024.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let storage = OAuth2TokenStorage()
    
    private let showAuthenticationScreenSegueIdentifier = "showAuthenticationScreenSegueIdentifier"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if storage.token != nil {
            showBarController()
        }
        else{
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
}

extension SplashViewController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func showBarController(){
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        
        window.rootViewController = tabBarController
    }
}

extension SplashViewController:AuthViewControllerDelegate{
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        showBarController()
    }
    
    
}
